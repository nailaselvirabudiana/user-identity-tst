import React, { useState, useEffect } from 'react'
import { getUsers, createUser, updateUser, updateUserStatus } from '../api/api'
import UserModal from '../components/UserModal'

function AdminDashboard({ user, onLogout }) {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [showModal, setShowModal] = useState(false)
  const [editingUser, setEditingUser] = useState(null)
  const [filterStatus, setFilterStatus] = useState('all')

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      const data = await getUsers()
      setUsers(data)
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal mengambil data users')
    } finally {
      setLoading(false)
    }
  }

  const handleCreateUser = () => {
    setEditingUser(null)
    setShowModal(true)
  }

  const handleEditUser = (user) => {
    setEditingUser(user)
    setShowModal(true)
  }

  const handleSaveUser = async (userData) => {
    try {
      if (editingUser) {
        await updateUser(editingUser.id, userData)
      } else {
        await createUser(userData)
      }
      setShowModal(false)
      fetchUsers()
    } catch (err) {
      throw err
    }
  }

  const handleStatusChange = async (userId, newStatus) => {
    try {
      await updateUserStatus(userId, newStatus)
      fetchUsers()
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal mengubah status')
    }
  }

  const filteredUsers = filterStatus === 'all' 
    ? users 
    : users.filter(u => u.status === filterStatus)

  if (loading) {
    return <div className="loading">Loading...</div>
  }

  return (
    <div>
      <div className="header">
        <div>
          <h1>Admin Dashboard</h1>
          <p style={{ color: '#666', marginTop: '4px' }}>Welcome, {user.name}</p>
        </div>
        <button onClick={onLogout} className="btn btn-secondary">Logout</button>
      </div>

      <div className="container">
        {error && <div className="error-message">{error}</div>}
        
        <div className="card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
            <h2>Manajemen Karyawan</h2>
            <button onClick={handleCreateUser} className="btn btn-primary">
              + Tambah Karyawan
            </button>
          </div>

          <div style={{ marginBottom: '20px' }}>
            <label style={{ marginRight: '10px', fontWeight: '500' }}>Filter Status:</label>
            <select 
              value={filterStatus} 
              onChange={(e) => setFilterStatus(e.target.value)}
              style={{ padding: '8px 12px', borderRadius: '4px', border: '1px solid #ddd' }}
            >
              <option value="all">Semua</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
              <option value="resigned">Resigned</option>
            </select>
            <span style={{ marginLeft: '15px', color: '#666' }}>
              Total: {filteredUsers.length} karyawan
            </span>
          </div>

          <table className="table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((u) => (
                <tr key={u.id}>
                  <td>{u.id}</td>
                  <td>{u.name}</td>
                  <td>{u.email}</td>
                  <td>
                    <span className={`badge badge-${u.role}`}>{u.role}</span>
                  </td>
                  <td>
                    <select
                      value={u.status}
                      onChange={(e) => handleStatusChange(u.id, e.target.value)}
                      style={{ padding: '4px 8px', borderRadius: '4px', border: '1px solid #ddd' }}
                    >
                      <option value="active">Active</option>
                      <option value="inactive">Inactive</option>
                      <option value="resigned">Resigned</option>
                    </select>
                  </td>
                  <td>
                    <button 
                      onClick={() => handleEditUser(u)} 
                      className="btn btn-primary"
                      style={{ fontSize: '12px', padding: '6px 12px' }}
                    >
                      Edit
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {showModal && (
        <UserModal
          user={editingUser}
          onSave={handleSaveUser}
          onClose={() => setShowModal(false)}
        />
      )}
    </div>
  )
}

export default AdminDashboard
