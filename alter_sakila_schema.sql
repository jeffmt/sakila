USE sakila;

--
-- Modify staff table
--
ALTER TABLE staff MODIFY password VARCHAR(70) BINARY DEFAULT NULL;
