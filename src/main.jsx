import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { MyProvider } from './context'
import App from './App.jsx'

createRoot(document.getElementById('root')).render(
  <MyProvider>
    <App />
  </MyProvider>,
)
