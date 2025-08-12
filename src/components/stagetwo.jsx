import {useContext} from 'react'
import {MyContext} from '../context';
const Stage2=()=>{
    const context = useContext(MyContext);
    const resetGame=()=>{
        context.resetGame();
    }
    return(
        <>
         <div className="result_wrapper">
            <h3>The looser is</h3>
            {context.result}
         </div>
        
         <div className="action_button btn_1" onClick={()=>resetGame()}>
            RESET GAME
         </div>
         <div className="action_button btn_2" onClick={()=>context.getLooser()}>
            GET LOOSERS
         </div>
        </>
    )
}
export default Stage2;