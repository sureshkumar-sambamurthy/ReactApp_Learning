import {useState,createContext} from 'react';
import { ToastContainer, toast } from 'react-toastify';
const MyContext = createContext(); //instatiate context

const MyProvider = (props)=>{

    const [stage,setStage] = useState(1);
    const [player,setPlayer] = useState([]);
    const [result,setResult]= useState('');

    const addPlayerHandler = (name)=>{
        setPlayer(prevState=>([
            ...prevState,
            name
        ]))
    }
    const removePlayerhandler = (idx)=>{
        let newPlayer=[...player];
        newPlayer.splice(idx,1);
      setPlayer(newPlayer);
    }
    const nextStageHandler=()=>{
        if(player.length < 2){
            toast.error(("Required alteat two players"))
        }else{
            setStage(2);
            setTimeout(()=>{
                generateLooser();
            },2000)
        }
    }
    const generateLooser=()=>{
        let result = player[Math.floor(Math.random()*player.length)];
        setResult(result)
    }
    const resetGameHandler=()=>{
        setResult('')
        setStage(1);
    }

    return(
        <>
          <ToastContainer />
        <MyContext.Provider value={{
            stage,
            player,
            result,
            addPlayer:addPlayerHandler,
            removePlayer:removePlayerhandler,
            nextStage:nextStageHandler,
            resetGame:resetGameHandler,
            getLooser:generateLooser
        }}>
        {props.children}
        </MyContext.Provider>
        </>
    )
}
export {MyContext,MyProvider}