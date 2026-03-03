# Insight Places – MySQL Stored Procedures Development

This repository contains the full development process of MySQL stored procedures created for the **Insight Places** platform — a fictional seasonal accommodation rental service inspired by platforms like Airbnb and Booking.  
The project is part of a hands-on SQL learning path and progressively introduces more complex procedure logic, validations, and best practices.

---

## 📌 About Insight Places  
**Insight Places** is a platform that manages short-term accommodation rentals. Users can book apartments, rooms, or vacation homes for specific dates.  
To correctly register a rental, the database must record key information such as:

- Identification of the accommodation  
- Identification of the guest  
- Sequential rental transaction ID  
- Check-in and check-out dates  
- Total amount to be paid  

This repository focuses on solving the problem of **correctly registering rentals** within the database by building a series of stored procedures, each more complete than the previous one.

---

## 📚 What This Repository Contains

The project documents the step-by-step evolution of multiple MySQL stored procedures, including:

### ✔ Basic procedures  
- Returning default values  
- Inserting fixed data into the `reservas` table  

### ✔ Parameterized procedures  
- Inserting rentals using parameters (reservation ID, client, dates, prices)

### ✔ Calculations  
- Automatic calculation of total price  
- Calculation of rental duration using `DATEDIFF`  
- Calculation of final date while skipping weekends  

### ✔ Validations  
- Checking if client exists  
- Detecting duplicate client names  
- Handling cases with zero, one, or multiple matching clients  

### ✔ Error handling  
- Using `EXIT HANDLER` to manage foreign key constraint errors  
- Returning custom messages for operational feedback  

### ✔ Business logic evolution  
- Simple inserts → validated inserts → inserts with date calculation → inserts with error handling → multi-condition procedures

---

## 🧠 Learning Objective

This repository demonstrates how to progressively build robust database logic using:

- MySQL stored procedures  
- Variables  
- Conditional structures (`IF`, `ELSEIF`, `CASE`)  
- Loops (`WHILE`)  
- Error handling  
- Data integrity validations  

It serves as a learning portfolio for database development and SQL problem-solving.

## 🤝 Contributions

This repository is educational but open for improvements.
Feel free to submit suggestions, refactorings, or enhancements.

---
