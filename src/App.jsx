import { useState, useEffect } from 'react'
import './App.css'

console.log('API URL:', import.meta.env.VITE_API_URL)

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api'



function App() {
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [newItem, setNewItem] = useState({ name: '', description: '' })

  useEffect(() => {
    fetchItems()
    checkHealth()
  }, [])

  const checkHealth = async () => {
    try {
      const response = await fetch(`${API_URL}/health/`)
      const data = await response.json()
      console.log('API Health:', data)
    } catch (err) {
      console.error('Health check failed:', err)
    }
  }

  const fetchItems = async () => {
    try {
      setLoading(true)
      const response = await fetch(`${API_URL}/items/`)
      if (!response.ok) throw new Error('Failed to fetch items')
      const data = await response.json()
      setItems(data.results || data)
      setError(null)
    } catch (err) {
      setError(err.message)
      console.error('Error fetching items:', err)
    } finally {
      setLoading(false)
    }
  }

  const addItem = async (e) => {
    e.preventDefault()
    if (!newItem.name.trim()) return

    try {
      const response = await fetch(`${API_URL}/items/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newItem),
      })
      if (!response.ok) throw new Error('Failed to add item')
      const data = await response.json()
      setItems([data, ...items])
      setNewItem({ name: '', description: '' })
    } catch (err) {
      setError(err.message)
      console.error('Error adding item:', err)
    }
  }

  const toggleComplete = async (id, completed) => {
    try {
      const response = await fetch(`${API_URL}/items/${id}/`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ completed: !completed }),
      })
      if (!response.ok) throw new Error('Failed to update item')
      const data = await response.json()
      setItems(items.map(item => item.id === id ? data : item))
    } catch (err) {
      setError(err.message)
      console.error('Error updating item:', err)
    }
  }

  const deleteItem = async (id) => {
    try {
      const response = await fetch(`${API_URL}/items/${id}/`, {
        method: 'DELETE',
      })
      if (!response.ok) throw new Error('Failed to delete item')
      setItems(items.filter(item => item.id !== id))
    } catch (err) {
      setError(err.message)
      console.error('Error deleting item:', err)
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <h1>React + Django App</h1>
        
        {error && (
          <div className="error-message">
            Error: {error}
            <button onClick={fetchItems}>Retry</button>
          </div>
        )}

        <div className="card">
          <h2>Add New Item</h2>
          <form onSubmit={addItem}>
            <input
              type="text"
              placeholder="Item name"
              value={newItem.name}
              onChange={(e) => setNewItem({ ...newItem, name: e.target.value })}
              className="input-field"
            />
            <textarea
              placeholder="Description (optional)"
              value={newItem.description}
              onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}
              className="input-field"
              rows="3"
            />
            <button type="submit">Add Item</button>
          </form>
        </div>

        <div className="card">
          <h2>Items List</h2>
          {loading ? (
            <p>Loading...</p>
          ) : items.length === 0 ? (
            <p>No items yet. Add one above!</p>
          ) : (
            <ul className="items-list">
              {items.map((item) => (
                <li key={item.id} className={item.completed ? 'completed' : ''}>
                  <div className="item-content">
                    <h3>{item.name}</h3>
                    {item.description && <p>{item.description}</p>}
                    <small>
                      Created: {new Date(item.created_at).toLocaleDateString()}
                    </small>
                  </div>
                  <div className="item-actions">
                    <button
                      onClick={() => toggleComplete(item.id, item.completed)}
                      className={item.completed ? 'btn-complete' : 'btn-incomplete'}
                    >
                      {item.completed ? '✓ Done' : 'Mark Done'}
                    </button>
                    <button
                      onClick={() => deleteItem(item.id)}
                      className="btn-delete"
                    >
                      Delete
                    </button>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </div>
      </header>
    </div>
  )
}

export default App
