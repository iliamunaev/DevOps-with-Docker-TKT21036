FROM ubuntu:latest

# Create a non-root user and set it up
RUN useradd -ms /bin/bash myuser

WORKDIR /usr/src

RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Verify installation
RUN node -v && npm -v

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install packages
RUN npm install

# Copy the rest of the application
COPY . .

# Change ownership of the working directory
RUN chown -R myuser:myuser /usr/src

# Switch to the non-root user
USER myuser

# Set env for backend
ENV REACT_APP_BACKEND_URL=http://localhost/api

# Build static files
RUN npm run build

# Install server
RUN npm install -g serve

EXPOSE 5000

CMD ["serve", "-s", "-l", "5000", "build"]
