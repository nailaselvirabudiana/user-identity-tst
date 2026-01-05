import axios from 'axios'

const API_URL = 'http://localhost:3040/api'

const api = axios.create({
  baseURL: API_URL
})

// Add token to all requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Auth
export const login = async (email, password) => {
  const response = await api.post('/auth/login', { email, password })
  return response.data
}

// Users
export const getUsers = async () => {
  const response = await api.get('/users')
  return response.data
}

export const getUser = async (id) => {
  const response = await api.get(`/users/${id}`)
  return response.data
}

export const createUser = async (userData) => {
  const response = await api.post('/users', userData)
  return response.data
}

export const updateUser = async (id, userData) => {
  const response = await api.patch(`/users/${id}`, userData)
  return response.data
}

export const updateUserStatus = async (id, status) => {
  const response = await api.patch(`/users/${id}/status`, { status })
  return response.data
}

export default api
