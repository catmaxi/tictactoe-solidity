// pragma solidity ^0.8.0;


// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// contract Tictactoe is Ownable {
    
//     bool public canPlay;
    
//     uint256 public gameState;
    
//     // this will be the board of the tictactoa game
//     uint8[3][3] public board;
    
//     address public player1;
//     address public player2;
    
//     uint256 public rows;
//     uint256 public cols;
//     uint256 public currentTurn;
    
//     uint256 public winCondition;
    
//     constructor (address _player1, address _player2) Ownable() {
//         canPlay = true;
//         resetBoard();
//         player1 = _player1;
//         player2 = _player2;
//     }
    
//     function setPlayer(uint256 _playerNumber, address _playerAddress) public onlyOwner{
//         // require((_playerNumber == 1 || _playerNumber == 2), "Can only set player 1 or player 2!");
//         if(_playerNumber == 1){
//             player1 = _playerAddress;
//         } else if (_playerNumber == 2){
//             player2 = _playerAddress;
//         } else {
//             revert("Can only set player 1 or player 2!");
//         }
//     }
    
//     function resetBoard() public {
//         rows = 3;
//         cols = 3;
//         winCondition = 3;
//         currentTurn = 0;
//         gameState = 0;
//         currentTurn = 1;
//         board = [
//             [0, 0, 0],
//             [0, 0, 0],
//             [0, 0, 0]
//         ];
//     }
    
//     function checkWin() public view returns(uint256){
//         // uint256 win = 0;
        
//         for(uint256 i = 0; i < rows; i++){
//             if(board[i][0] == 1 && board[i][1] == 1 && board[i][2] == 1){
//                 return 1;
//             }
//             if(board[i][0] == 2 && board[i][1] == 2 && board[i][2] == 2){
//                 return 2;
//             }
//         }
        
//         for(uint256 i = 0; i < cols; i++){
//             if(board[0][i] == 1 && board[1][i] == 1 && board[2][i] == 1){
//                 return 1;
//             }
//             if(board[0][i] == 2 && board[1][i] == 2 && board[2][i] == 2){
//                 return 2;
//             }
//         }
        
//         // diagonals
//         if(board[0][0] == 1 && board[1][1] == 1 && board[2][2] == 1){
//             return 1;
//         }
//         if(board[0][0] == 2 && board[1][1] == 2 && board[2][2] == 2){
//             return 2;
//         }
        
        
//         // diagonals
//         if(board[0][0] == 1 && board[1][1] == 1 && board[2][2] == 1){
//             return 1;
//         }
//         if(board[0][0] == 2 && board[1][1] == 2 && board[2][2] == 2){
//             return 2;
//         }
        
        
//         if(board[2][0] == 1 && board[1][1] == 1 && board[0][2] == 1){
//             return 1;
//         }
//         if(board[2][0] == 2 && board[1][1] == 2 && board[0][2] == 2){
//             return 2;
//         }
        
        
//         // no win
//         return 0;
//     }
    
//     event Win(address winPlayerAddress, uint256 winner);
    
//     function player1Play(uint256 _row, uint256 _col) public {
//         require(canPlay, "Game is paused!");
//         require(msg.sender == player1, "Must be played by player 1");
//         require(_row >= 0 && _row < rows && _col >= 0 && _col < cols, "Move is outside of board");
//         require(board[_row][_col] == 0, "This move has already been taken!");
//         require(currentTurn == 1, "Not your turn");
//         board[_row][_col] = 1;
        
        
//         if(checkWin() == 1){
//             gameState = 1;
//             emit Win(player1, 1);
//         }
       
//        currentTurn = 2;
//     }
    
//     function player2Play(uint256 _row, uint256 _col) public {
//         require(canPlay, "Game is paused!");
//         require(msg.sender == player2, "Must be played by player 2");
//         require(_row >= 0 && _row < rows && _col >= 0 && _col < cols, "Move is outside of board");
//         require(board[_row][_col] == 0, "This move has already been taken!");
//         require(currentTurn == 2, "Not your turn");
//         board[_row][_col] = 2;
        
//         if(checkWin() == 2){
//             gameState = 2;
//             emit Win(player2, 2);
//         }
//         currentTurn = 1;
//     }
    
//     function printBoard() public view returns(uint256[3][3] memory){
//         uint256[3][3] memory tmp;
//         for (uint i = 0; i < rows; i++){
//             for (uint j = 0; j < rows; j++){
//                 tmp[i][j] = board[i][j];
//             }
//         }
//         return tmp;
//     }

    
//     function pauseGame() public onlyOwner {
//         canPlay = false;
//     }
    
//     function unpauseGame() public onlyOwner {
//         canPlay = true;
//     }
    
//     function getBoardValue(uint256 _row, uint256 _col) public view returns(uint8){
//         require(_row >= 0, "1");
//         require(_row < rows, "2");
//         require(_col >= 0, "3");
//         require(_col < cols, "4");
//         require(_row >= 0 && _row < rows && _col >= 0 && _col < cols, "Move is outside of board");
//         return board[_row][_col];
//     }
// }