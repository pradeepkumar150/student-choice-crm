const app = require('../app');
const pool = require('../config/db');

const demoPassword = process.env.DEMO_ADMIN_PASSWORD;
if (!demoPassword) throw new Error('Set DEMO_ADMIN_PASSWORD in backend/.env before running this verification.');

const server = app.listen(5011, async () => {
  try {
    const login = await fetch('http://127.0.0.1:5011/api/v1/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'demo.admin@example.com', password: demoPassword })
    });
    const auth = await login.json();
    if (!login.ok || !auth.token) throw new Error('Demo admin login failed');

    const headers = {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${auth.token}`
    };
    const create = await fetch('http://127.0.0.1:5011/api/v1/calls', {
      method: 'POST',
      headers,
      body: JSON.stringify({
        customerName: 'Demo Verification Contact',
        phone: '202-555-0191',
        status: 'pending',
        notes: 'Automated demo verification'
      })
    });
    const item = await create.json();
    if (!create.ok) throw new Error(item.error || 'Call creation failed');

    const update = await fetch(`http://127.0.0.1:5011/api/v1/calls/${item.call.id}`, {
      method: 'PATCH',
      headers,
      body: JSON.stringify({
        customerName: 'Demo Verification Contact',
        phone: '202-555-0191',
        status: 'connected',
        notes: 'Automated demo verification',
        markCalled: true
      })
    });
    const changed = await update.json();
    if (!update.ok || changed.call.status !== 'connected') {
      throw new Error(changed.error || 'Call update verification failed');
    }

    const bulk = await fetch('http://127.0.0.1:5011/api/v1/calls/bulk', {
      method: 'POST',
      headers,
      body: JSON.stringify({
        assignedTo: 1,
        calls: [
          { phone: '202-555-0192', customer_name: 'Demo Bulk Contact' },
          { phone: '202-555-0192', customer_name: 'Duplicate Demo Contact' },
          { phone: '202-555-0191', customer_name: 'Already Existing Demo Contact' }
        ]
      })
    });
    const bulkResult = await bulk.json();
    if (!bulk.ok || bulkResult.imported !== 1 || bulkResult.skippedDuplicates !== 2) {
      throw new Error(bulkResult.error || 'Bulk duplicate protection verification failed');
    }

    const list = await fetch('http://127.0.0.1:5011/api/v1/calls?search=Demo%20Bulk%20Contact', { headers });
    const callRows = await list.json();
    for (const row of callRows.calls) {
      await fetch(`http://127.0.0.1:5011/api/v1/calls/${row.id}`, { method: 'DELETE', headers });
    }
    await fetch(`http://127.0.0.1:5011/api/v1/calls/${item.call.id}`, { method: 'DELETE', headers });

    console.log(`Call CRUD verified: ${changed.call.status}; bulk import: ${bulkResult.imported} imported / ${bulkResult.skippedDuplicates} duplicates skipped`);
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  } finally {
    server.close(async () => {
      await pool.end();
    });
  }
});
