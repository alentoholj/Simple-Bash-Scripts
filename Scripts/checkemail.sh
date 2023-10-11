#!/bin/bash

read -p "Enter email:" email

if [[ "$email" =~ ^[A-Za-z0-0.%]+@[A-Za-z0-9{3,8}]+\.[A-Za-z]{2,4} ]]
then
    echo "Email address $email is valid."
else
    echo "Email address $email is invalid. Please type again."
fi