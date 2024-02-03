#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display the menu
display_menu() {
    echo -e "${GREEN}Select an option:${NC}"
    echo -e "${GREEN}1 - Start container${NC}"
    echo -e "${GREEN}2 - Stop container${NC}"
    echo -e "${GREEN}3 - Restart container${NC}"
    echo -e "${GREEN}4 - Display container status${NC}"
    echo -e "${GREEN}q - Exit${NC}"
}

# Function to start the container
start_container() {
    docker-compose -p postfix up -d
}

# Function to stop the container
stop_container() {
    docker-compose -p postfix down
}

# Function to restart the container
restart_container() {
    docker-compose -p postfix down
    docker-compose -p postfix up -d
    docker ps -a
}

# Function to display container status
display_status() {
    docker ps -a
}

# Main script
while true; do
    display_menu

    read -p "Enter your choice (1-4, q): " choice

    case "$choice" in
        1)
            restart_container
            ;;
        2)
            stop_container
            ;;
        3)
            start_container
            ;;
        4)
            display_status
            ;;
        q)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 4, or 'q' to exit."
            ;;
    esac

    read -p "Press Enter to continue..."
    clear  # Clear the screen for the next iteration
done