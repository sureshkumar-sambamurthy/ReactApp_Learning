import {useContext} from 'react';
import {MyContext} from './context';
import Stage1 from './components/stageone';
import Stage2 from './components/stagetwo';
import 'bootstrap/dist/css/bootstrap.min.css';
import './style/app.css'
function App() {
  const context = useContext(MyContext);
  return (
    <>
    <div className="wrapper">
      <div className="center-wrapper">
        <h1>Who pays the bills</h1>
        {context.stage ==1 ?
        <Stage1/>
      :
       <Stage2/>
       }
      </div>
    </div>
    
      
     </>
  )
}

export default App
