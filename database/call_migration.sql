USE student_choice_crm;
CREATE TABLE IF NOT EXISTS calls (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lead_id INT UNSIGNED NULL,
  customer_name VARCHAR(120) NOT NULL,
  phone VARCHAR(25) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'pending',
  notes TEXT,
  follow_up_at DATETIME NULL,
  last_called_at DATETIME NULL,
  call_count INT UNSIGNED NOT NULL DEFAULT 0,
  assigned_to INT UNSIGNED NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_calls_status(status), INDEX idx_calls_assigned_to(assigned_to), INDEX idx_calls_follow_up(follow_up_at),
  CONSTRAINT fk_call_lead FOREIGN KEY (lead_id) REFERENCES leads(id) ON DELETE SET NULL,
  CONSTRAINT fk_call_assignee FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;
