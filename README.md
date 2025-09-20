
# SPARK is not ready for now, please dont try to build a project with it
# the next lines are a roadmap, but Spark dont achive his objectives for now 

Spark is a full web app boilerplate designed to help beginners start building modern applications with clarity and good practices.  
It is not meant to be a universal solution, but rather a practical guide built on a solid and modern stack.

The main goal of Spark is to:
- Provide a ready-to-use structure for React, Node.js, and supporting tools.  
- Offer clear documentation and examples to explain concepts and guide developers.  
- Encourage learning by practice, helping beginners avoid outdated tutorials or bad practices.  

Spark is not intended to cover everything or make you a perfect developer.  
But if you take the time to explore, search, and understand what you find here, it will give you strong foundations and a clear path forward.

## Stack Overview

Spark is built on a modern and solid stack:

- **Frontend**: React (Vite)
- **Backend**: Node.js, Express, Knex
- **Infrastructure**: Docker Compose, Nginx, Certbot
- **Tooling**: ESLint, Dockerfiles, environment management

---

## File Structure

Spark provides a clear and consistent file structure:

- **client/** → React application  
- **api/** → Node.js backend with Express and Knex  
- **ENVIRONMENT/** → Environment variables for production and development  
- **/** (root) → Global configuration and tools  

Whenever you feel lost inside a folder, check if a README is present.  
Each non-intuitive part of this boilerplate will contain a README that explains the concepts and points you toward what you need to study.  

---

## Base Configuration

- **Environment Variables**  
  - `.env` files for production and development  

- **Docker Compose**  
  - Nginx reverse proxy  
  - Certbot for HTTPS certificates  
  - Dockerfiles for client and API  

- **Node.js**  
  - ESLint configuration  
  - Knex configuration (linked with `/ENVIRONMENT`)  

---

## Simplification Tools

- **envLoader.js** (client/ and api/)  
  Loads and validates environment variables, ensuring consistency across services.  

- **rocket.sh** (root)  
  A fast asynchronous script to back up, clone, update all containers, and restart them immediately.  
