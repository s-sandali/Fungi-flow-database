# 🧠 Mushroom Resource Management System (FungiFlow)

## 📖 Project Overview

This project implements an integrated SQL-based **Mushroom Resource Management System** for the **Mushroom Development and Training Centre (MTDC)**. It includes:

- 🌱 Raw material procurement and stock tracking  
- 🧪 Lab-based batch cultivation and contamination management  
- 🛍️ Sales processing (pre-orders & walk-ins)  
- 📊 Admin reports and stock alerts  

---

## 🏢 Business Context

**Organization**: Mushroom Development and Training Centre (MTDC)  
**Type**: Private Agricultural Enterprise  
**Scale**: 15 employees, responsible for ~85% of mushroom production in Sri Lanka  
**Location**: Dehiwala-Mount Lavinia

---

## 🧩 System Modules & Member Scopes

### 🔹 Inventory Management (Nethma)
- Manage suppliers and raw materials (seeds, bags)
- Allocate inventory across lab, sales, and storage
- Monitor low stock levels and auto-generate alerts

### 🔹 Lab Management (Sandali)
- Log mushroom cultivation batches
- Track daily growth & contamination
- Allocate viable cultures to sales and production
- Visualize growth success rates

### 🔹 Sales Management (Jayasinghe)
- Handle walk-in and pre-order sales
- Track branch-wise distribution
- Sync product stock with sales

### 🔹 Admin Dashboard (De Silva)
- Manage users and roles
- Approve purchase requests
- Generate performance reports (lab, inventory, sales)

---

## 📝 ER Diagram

![WhatsApp Image 2025-07-31 at 22 42 15_9865a765](https://github.com/user-attachments/assets/322d1c21-6732-4c2e-a148-1779218c5196)

## 📝 Mapping to relational database

![Untitled Diagram (3) (1)](https://github.com/user-attachments/assets/0849ca8c-d6f4-43dd-9838-37b9a1ad771d)


## 🧱 Database Design

The database is structured into 17 tables categorized by module:

- **Inventory Tables**  
  - `purchased_raw_material`, `inventory_item`, `material_transfer`, `supplier`

- **Lab Management Tables**  
  - `mushroom_type`, `batch`, `daily_update`, `batch_allocation`, `growth_outcome_by_types`

- **Sales & Distribution Tables**  
  - `product`, `preorder`, `walk_in_sales`, `branch`

- **Admin & User Tables**  
  - `employee`, `user`, `report`, `stock_alert`

---

## ⚙️ Core Features

- ✅ Secure login for all roles (RBAC)
- ✅ Real-time stock updates and alerts
- ✅ Pre-order prioritization in allocations
- ✅ Auto-removal of contaminated batches
- ✅ Report generation (PDF)
- ✅ Scalable design for adding mushroom types or branches

---

## 💡 Sample SQL Queries

Each module includes practical SQL operations such as:

- Add/update/delete records
- Stock and success rate calculations
- Daily contamination reports
- Branch-wise sales performance
- Real-time stock alert queries

---

## 🔐 Non-Functional Requirements

- **Security**: Enforced role-based access control with secure login  
- **Performance**: Simultaneous multi-user login supported  
- **Scalability**: Add new mushroom types, branches, or suppliers easily  
- **Usability**: Designed for minimal training and responsive UI  
- **Reliability**: System uptime during working hours guaranteed

---

## 📦 Technologies Used

- 💾 MySQL  
- 🗂️ SQL Scripts  
- 📐 ER Diagrams (draw.io or Lucidchart recommended)  
- 📝 Report Generation (PDF Format)

---

## 📌 Future Improvements

- Web-based interface with role-specific dashboards  
- Automated alerts via email or mobile notifications  
- Integration with mobile POS systems  
- Live performance dashboards with charts

---
## 📌 Module: SE2032 – Database Management Systems  
**Group Report Submission — Year 2, Semester 1**  
**Institution**: Sri Lanka Institute of Information Technology (SLIIT)  
**Submitted on**: May 02, 2025  
**Team ID**: Group 01

---

## 👥 Team Members

| Student ID     | Name              | Role / Module                          |
|----------------|-------------------|----------------------------------------|
| IT23651456     | Sandali J.S       | Lab Management                         |
| IT23592674     | A G S Nethma      | Inventory Management                   |
| IT23645684     | V N Jayasinghe    | Sales Management                       |
| IT23632028     | L G A I De Silva  | Admin Dashboard & Analytics            |

---

## 📄 License

This project was developed for academic purposes under the course SE2032 – Database Management Systems.

---




