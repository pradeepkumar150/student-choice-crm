USE student_choice_crm;

-- Fictional sample records for local demos only. All email addresses use example.com
-- and all phone numbers use the reserved 202-555-01xx range.
INSERT INTO leads
  (name, phone, email, country, university, loan_amount, student_name, co_applicant,
   occupation, source, remarks, login_city, sanction_city, credit_score, status, assigned_to)
SELECT 'Demo Student 001', '202-555-0101', 'student.001@example.com', 'Demo Country',
       'Example University', 100000, 'Demo Student 001', 'Demo Contact 001',
       'Student', 'Demo', 'Fictional record for local demonstration only.',
       'Demo City', '', 700, 'interested', NULL
WHERE NOT EXISTS (SELECT 1 FROM leads WHERE email = 'student.001@example.com');

INSERT INTO leads
  (name, phone, email, country, university, loan_amount, student_name, co_applicant,
   occupation, source, remarks, login_city, sanction_city, credit_score, status, assigned_to)
SELECT 'Demo Student 002', '202-555-0102', 'student.002@example.com', 'Demo Country',
       'Example Institute', 150000, 'Demo Student 002', 'Demo Contact 002',
       'Student', 'Demo', 'Fictional record for local demonstration only.',
       'Demo City', 'Demo City', 710, 'login', NULL
WHERE NOT EXISTS (SELECT 1 FROM leads WHERE email = 'student.002@example.com');

INSERT INTO leads
  (name, phone, email, country, university, loan_amount, student_name, co_applicant,
   occupation, source, remarks, login_city, sanction_city, credit_score, status, assigned_to)
SELECT 'Demo Student 003', '202-555-0103', 'student.003@example.com', 'Demo Country',
       'Sample College', 200000, 'Demo Student 003', 'Demo Contact 003',
       'Student', 'Demo', 'Fictional record for local demonstration only.',
       'Demo City', 'Demo City', 720, 'sanction', NULL
WHERE NOT EXISTS (SELECT 1 FROM leads WHERE email = 'student.003@example.com');

INSERT INTO calls (lead_id, customer_name, phone, status, notes, follow_up_at)
SELECT l.id, l.name, l.phone, 'pending', 'Demo: initial call pending.', NULL
FROM leads l
WHERE l.email = 'student.001@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM calls c WHERE c.lead_id = l.id AND c.notes = 'Demo: initial call pending.'
  );

INSERT INTO calls (lead_id, customer_name, phone, status, notes, follow_up_at)
SELECT l.id, l.name, l.phone, 'follow_up', 'Demo: follow-up scheduled.', DATE_ADD(NOW(), INTERVAL 1 DAY)
FROM leads l
WHERE l.email = 'student.002@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM calls c WHERE c.lead_id = l.id AND c.notes = 'Demo: follow-up scheduled.'
  );

INSERT INTO calls (lead_id, customer_name, phone, status, notes, follow_up_at)
SELECT l.id, l.name, l.phone, 'connected', 'Demo: sample connected call.', NULL
FROM leads l
WHERE l.email = 'student.003@example.com'
  AND NOT EXISTS (
    SELECT 1 FROM calls c WHERE c.lead_id = l.id AND c.notes = 'Demo: sample connected call.'
  );
