const bcrypt = require('bcryptjs');
const pool = require('../config/db');

async function seedDemoAdmin() {
  const password = process.env.DEMO_ADMIN_PASSWORD;
  if (!password || password.length < 16) {
    throw new Error('Set DEMO_ADMIN_PASSWORD to a unique password of at least 16 characters before seeding.');
  }

  const [roles] = await pool.execute('SELECT id FROM roles WHERE `key`=?', ['super_admin']);
  if (!roles[0]) throw new Error('Import database/schema.sql first');

  const hash = await bcrypt.hash(password, 12);
  await pool.execute(
    `INSERT INTO users (role_id,name,email,password,is_active)
     VALUES (?,?,?,?,1)
     ON DUPLICATE KEY UPDATE role_id=VALUES(role_id),name=VALUES(name),password=VALUES(password),is_active=1`,
    [roles[0].id, 'Demo Admin', 'demo.admin@example.com', hash]
  );
  console.log('Demo admin ready: demo.admin@example.com');
}

seedDemoAdmin()
  .then(() => pool.end())
  .catch(async error => {
    console.error(error.message);
    await pool.end();
    process.exit(1);
  });
