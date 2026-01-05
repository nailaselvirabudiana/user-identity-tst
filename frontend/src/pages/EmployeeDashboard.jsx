import React, { useState, useEffect } from 'react'
import { getUser, updateUser } from '../api/api'

function EmployeeDashboard({ user, onLogout }) {
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [editing, setEditing] = useState(false)
  const [formData, setFormData] = useState({ name: '', email: '' })

  useEffect(() => {
    fetchProfile()
  }, [])

  const fetchProfile = async () => {
    try {
      const data = await getUser(user.id)
      setProfile(data)
      setFormData({ name: data.name, email: data.email })
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal mengambil data profil')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    try {
      await updateUser(user.id, formData)
      setSuccess('Profil berhasil diperbarui')
      setEditing(false)
      fetchProfile()
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal memperbarui profil')
    }
  }

  const handleCancel = () => {
    setFormData({ name: profile.name, email: profile.email })
    setEditing(false)
  }

  if (loading) {
    return <div className="loading">Loading...</div>
  }

  return (
    <div>
      <div className="header">
        <div>
          <h1>Employee Dashboard</h1>
          <p style={{ color: '#666', marginTop: '4px' }}>Welcome, {user.name}</p>
        </div>
        <button onClick={onLogout} className="btn btn-secondary">Logout</button>
      </div>

      <div className="container">
        <div className="card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
            <h2>Profil Saya</h2>
            {!editing && (
              <button onClick={() => setEditing(true)} className="btn btn-primary">
                Edit Profil
              </button>
            )}
          </div>

          {error && <div className="error-message">{error}</div>}
          {success && <div className="success-message">{success}</div>}

          {!editing ? (
            <div>
              <div style={{ marginBottom: '16px' }}>
                <label style={{ display: 'block', fontWeight: '600', marginBottom: '4px' }}>ID Karyawan</label>
                <p>{profile?.id}</p>
              </div>
              <div style={{ marginBottom: '16px' }}>
                <label style={{ display: 'block', fontWeight: '600', marginBottom: '4px' }}>Nama</label>
                <p>{profile?.name}</p>
              </div>
              <div style={{ marginBottom: '16px' }}>
                <label style={{ display: 'block', fontWeight: '600', marginBottom: '4px' }}>Email</label>
                <p>{profile?.email}</p>
              </div>
              <div style={{ marginBottom: '16px' }}>
                <label style={{ display: 'block', fontWeight: '600', marginBottom: '4px' }}>Role</label>
                <span className={`badge badge-${profile?.role}`}>{profile?.role}</span>
              </div>
              <div style={{ marginBottom: '16px' }}>
                <label style={{ display: 'block', fontWeight: '600', marginBottom: '4px' }}>Status</label>
                <span className={`badge badge-${profile?.status}`}>{profile?.status}</span>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="name">Nama</label>
                <input
                  id="name"
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label htmlFor="email">Email</label>
                <input
                  id="email"
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  required
                />
              </div>
              <div style={{ display: 'flex', gap: '10px' }}>
                <button type="submit" className="btn btn-success">Simpan</button>
                <button type="button" onClick={handleCancel} className="btn btn-secondary">Batal</button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}

export default EmployeeDashboard
