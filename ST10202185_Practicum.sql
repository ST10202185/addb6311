--Question 2
CREATE USER "JOHNSMITH" IDENTIFIED BY Password1;
CREATE ROLE ADMINISTRATOR;
GRANT ALL PRIVILEGES ON SCHEMA ST10202185_Practicum TO ADMINISTRATOR;
GRANT ADMINISTRATOR TO "JOHNSMITH";

CREATE ROLE GENERAL_USER;
GRANT SELECT, INSERT, UPDATE, DELETE ON ST10202185_Practicum TO GENERAL_USER;
CREATE USER "SIYA" IDENTIFIED BY Password1;
GRANT GENERAL_USER TO "JOHN SMITH";


--Question 3
SELECT i.INS_FNAME || ' ' || i.INS_SNAME AS "INSTRUCTOR",
       c.CUST_FNAME || ' ' || c.CUST_SNAME AS "CUSTOMER",
       de.DIVE_ID,
       de.DIVE_DATE,
       de.DIVE_PARTICIPANTS AS "DIVE_PARTICIPANTS"
FROM Dive_Event de
JOIN Instructor I ON de.INS_ID = i.INS_ID
JOIN Customer c ON de.CUST_ID = c.CUST_ID
WHERE de.DIVE_PARTICIPANTS >= 8;


--Question 4
DECLARE
    V_dive_name VARCHAR2(100);
    V_dive_date DATE;
    V_participants NUMBER;
BEGIN
    FOR dive_rec IN (SELECT d.DIVE_NAME, de.DIVE_DATE, de.DIVE_PARTICIPANTS
                     FROM Dive_Event de
                     JOIN Dive d ON de.DIVE_ID = d.DIVE_ID
                     WHERE de.DIVE_PARTICIPANTS >= 10)
    LOOP
        V_dive_name := dive_rec.DIVE_NAME;
        V_dive_date := dive_rec.DIVE_DATE;
        V_participants := dive_rec.DIVE_PARTICIPANTS;
        
        DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || v_dive_name);
        DBMS_OUTPUT.PUT_LINE('DIVE DATE: ' || TO_CHAR(v_dive_date, 'DD/MON/YY'));
        DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || v_participants);
    END LOOP;
END;


--Question 5
DECLARE
    V_customer_name VARCHAR2(100);
    V_dive_name VARCHAR2(100);
    V_participants NUMBER;
    V_instructors_required NUMBER;
BEGIN
    FOR dive_rec IN (SELECT c.CUST_FNAME || ', ' || c.CUST_SNAME AS customer_name,
                             d.DIVE_NAME,
                             de.DIVE_PARTICIPANTS,
                             d.DIVE_COST
                      FROM Dive_Event de
                      JOIN Customer c ON de.CUST_ID = c.CUST_ID
                      JOIN Dive d ON de.DIVE_ID = d.DIVE_ID
                      WHERE d.DIVE_COST > 500)
    LOOP
        V_customer_name := dive_rec.customer_name;
        V_dive_name := dive_rec.DIVE_NAME;
        V_participants := dive_rec.DIVE_PARTICIPANTS;
        
        IF V_participants <= 4 THEN
            V_instructors_required := 1;
        ELSIF V_participants BETWEEN 5 AND 7 THEN
            V_instructors_required := 2;
        ELSE
            V_instructors_required := 3;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('CUSTOMER: ' || V_customer_name);
        DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || V_dive_name);
        DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || V_participants);
        DBMS_OUTPUT.PUT_LINE('STATUS: ' || V_instructors_required || ' instructors required.');
    END LOOP;
END;



--Question 6
CREATE VIEW Vw_Dive_Event AS
SELECT de.INS_ID,
       de.CUST_ID,
       c.CUST_ADDRESS,
       d.DIVE_DURATION,
       de.DIVE_DATE
FROM Dive_Event de
JOIN Customer c ON de.CUST_ID = c.CUST_ID
JOIN Dive d ON de.DIVE_ID = d.DIVE_ID
WHERE de.DIVE_DATE < TO_DATE('2017-07-19', 'YYYY-MM-DD');



--Question 7
CREATE OR REPLACE TRIGGER New_Dive_Event
BEFORE INSERT ON Dive_Event
FOR EACH ROW
BEGIN
    IF :NEW.DIVE_PARTICIPANTS <= 0 OR :NEW.DIVE_PARTICIPANTS > 20 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid number of participants. Please enter a value between 1 and 20.');
    END IF;
END;


INSERT INTO Dive_Event (DIVE_EVENT_ID, DIVE_DATE, DIVE_PARTICIPANTS, INS_ID, CUST_ID, DIVE_ID)
VALUES ('de110', '2017-07-30', 0, '101', 'C115', 554);

INSERT INTO Dive_Event (DIVE_EVENT_ID, DIVE_DATE, DIVE_PARTICIPANTS, INS_ID, CUST_ID, DIVE_ID)
VALUES (‘de111’, ‘2017-08-05’, 25, ‘102’, ‘C117’, 555);

INSERT INTO Dive_Event (DIVE_EVENT_ID, DIVE_DATE, DIVE_PARTICIPANTS, INS_ID, CUST_ID, DIVE_ID)
VALUES (‘de112’, ‘2017-08-10’, 15, ‘103’, ‘C118’, 552);



--Question 8
CREATE OR REPLACE PROCEDURE sp_Customer_Details(
    P_cust_id IN VARCHAR2,
    P_dive_date IN DATE
)
IS
    V_customer_name VARCHAR2(100);
    V_dive_name VARCHAR2(100);
BEGIN
    SELECT c.CUST_FNAME || ' ' || c.CUST_SNAME, d.DIVE_NAME
    INTO V_customer_name, V_dive_name
    FROM Dive_Event de
    JOIN Customer c ON de.CUST_ID = c.CUST_ID
    JOIN Dive d ON de.DIVE_ID = d.DIVE_ID
    WHERE de.CUST_ID = P_cust_id
    AND de.DIVE_DATE = P_dive_date;
    
    DBMS_OUTPUT.PUT_LINE('CUSTOMER DETAILS: ' || V_customer_name || ' booked for the ' || V_dive_name || ' on the ' || TO_CHAR(P_dive_date, 'DD/MON/YY') || '.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No customer found for the given customer ID and dive date.');
END;
/
EXEC sp_Customer_Details('C118', TO_DATE('2017-07-18', 'YYYY-MM-DD'));



--Question 9
CREATE OR REPLACE FUNCTION calculate_discount(
    p_price IN NUMBER
) RETURN NUMBER
IS
    v_discount NUMBER;
BEGIN
    IF p_price <= 500 THEN
        v_discount := p_price * 0.1; -- 10% discount
    ELSE
        v_discount := p_price * 0.2; -- 20% discount
    END IF;
    
    RETURN v_discount;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL; -- Return NULL in case of any exception
END;
/
SELECT calculate_discount(600) AS discount FROM dual;


--Question10
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(‘1. Customer Details’);
    DBMS_OUTPUT.PUT_LINE(‘2. Dive Adjustments’);
    DBMS_OUTPUT.PUT_LINE(‘3. Exit’);

?	Get user input
    DECLARE
        V_choice NUMBER;
    BEGIN
        V_choice := &v_choice; -- Prompt user to enter their choice
        CASE v_choice
            WHEN 1 THEN
?	Call procedure or function to display customer details report
                NULL;
            WHEN 2 THEN
?	Call procedure or function to display dive adjustments report
                NULL;
            WHEN 3 THEN
                DBMS_OUTPUT.PUT_LINE(‘Exiting…’);
            ELSE
                DBMS_OUTPUT.PUT_LINE(‘Invalid choice. Please enter a valid option.’);
        END CASE;
    END;
END;
