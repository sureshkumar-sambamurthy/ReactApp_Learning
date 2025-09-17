import { MyContext } from '../context/index';import { MyContext } from '../contexteds';
const Stage1=()=>{
    const playerInput = useRef();
    const context = useContext(MyContext);
    const [error,setError] = useState([false,'']);
    const handleSubmit=(e)=>{
        e.preventDefault();
       let player = playerInput.current.value;
       let isValid = validateInput(player);
       if(isValid){
            setError([false,''])
            context.addPlayer(player)
            playerInput.current.value='';
       }
    }
    const validateInput =(value)=>{
       if(value === ''){
         setError([true,'Sorry player name is required']);
         return false;
       }
       if(value.length <=2){
        setError([true,'Sorry player name should be minimum 3 characters']);
        return false;
       }
       return true;
    }
    console.log(context)
    return(
        <>
       <Form onSubmit={handleSubmit}>
        <Form.Group>
            <Form.Control 
             type="text"
             placeholder='Add Players'
             ref={playerInput}
            />
        </Form.Group>
        {error[0]? <Alert>{error[1]}</Alert>:''}
        <Button className="miami" type="submit" variant='primary'>
            Add Player
        </Button>
        {context.player && context.player.length>0?
            <>
            <hr/>
            <div>
             <ul className="list-group">
                {context.player.map((player,idx)=>(
                    <li key={idx} className='list-group-item d-flex justify-content-between align-items-center list-group-item-action'>{player}
                    <span className='badge badge-danger' onClick={()=>context.removePlayer(idx)}>x</span>
                    </li>
                ))}
             </ul>
             <div className="action_button" onClick={()=>context.nextStage()}>
                NEXT
             </div>
             </div>
            </>
        :null}
       </Form>
       </>
    )
}

export default Stage1