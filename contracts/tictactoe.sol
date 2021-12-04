// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import '@openzeppelin/contracts/access/Ownable.sol';


contract Tictactoe {

    
    struct Game {
        uint gameId;
        uint8[3][3] board;
        uint8 turn;
        uint8 winner;
        uint8 gameState;
        address player1;
        address player2;
        uint stepsPlayed;
    }

    Game[] public gameList;


    event GameCreated(uint gameId);
    event GameJoined(uint gameId, address player, uint8 playerNumber);
    event GameStarted(uint gameId);
    event GameFinished(uint gameId, uint8 winner, uint stepsPlayed);
    event GameStep(uint gameId, uint8 playerNumber, uint8 x, uint8 y, uint step);


    constructor() {
        
    }

    function getGame(uint _gameId) public view returns (Game memory) {
        return gameList[_gameId];
    }

    function getGamePlayerNumber(uint _gameId, address _player) public view returns (uint8 playerNumber) {
        Game memory game = gameList[_gameId];
        if (game.player1 == _player) {
            return 1;
        } else if (game.player2 == _player) {
            return 2;
        } else {
            revert("Player not found");
            // return 0;
        }
    }

    function getGamePlayerAddress(uint _gameId, uint8 _playerNumber) public view returns (address player) {
        Game memory game = gameList[_gameId];
        if (_playerNumber == 1) {
            return game.player1;
        } else if (_playerNumber == 2) {
            return game.player2;
        } else {
            revert("Player not found");
            // return address(0);
        }
    }



    function createNewGame() public returns (uint) {
        Game memory game = Game({
            gameId: gameList.length,
            board: [
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0]
            ],
            turn: 0,
            winner: 0,
            player1: msg.sender,
            player2: address(0),
            stepsPlayed: 0,
            gameState: 0
        });

        gameList.push(game);

        emit GameCreated(game.gameId);

        return game.gameId;
    }


    function joinGame(uint _gameId) public returns (uint) {
        require(_gameId < gameList.length);
        require(gameList[_gameId].gameState == 0);
        require(gameList[_gameId].player2 == address(0));

        Game memory game = gameList[_gameId];

        game.player2 = msg.sender;
        game.gameState = 1;

        emit GameJoined(game.gameId, msg.sender, 2);

        return game.gameId;
    }

    function startGame(uint _gameId) public returns (uint) {
        require(_gameId < gameList.length);
        require(gameList[_gameId].gameState == 1);
        require(gameList[_gameId].player2 != address(0));

        Game memory game = gameList[_gameId];

        game.gameState = 2;

        emit GameStarted(game.gameId);

        return game.gameId;
    }


    function checkWin(uint _gameId) public view returns (uint8 winner) {
        require(_gameId < gameList.length);
        require(gameList[_gameId].gameState == 2);

        Game memory game = gameList[_gameId];

        uint8[3][3] memory board = game.board;

        uint8 x = 0;
        uint8 y = 0;

        if (board[0][0] == board[0][1] && board[0][1] == board[0][2]) {
            winner = board[0][0];
        } else if (board[1][0] == board[1][1] && board[1][1] == board[1][2]) {
            winner = board[1][0];
        } else if (board[2][0] == board[2][1] && board[2][1] == board[2][2]) {
            winner = board[2][0];
        } else if (board[0][0] == board[1][0] && board[1][0] == board[2][0]) {
            winner = board[0][0];
        } else if (board[0][1] == board[1][1] && board[1][1] == board[2][1]) {
            winner = board[0][1];

        } else if (board[0][2] == board[1][2] && board[1][2] == board[2][2]) {
            winner = board[0][2];
        } else if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
            winner = board[0][0];
        } else if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
            winner = board[0][2];
        } else {
            winner = 0;
        }

        return winner;

    }


    // player number problem
    function move(uint _gameId, uint8 _playerNumber, uint8 x, uint8 y) public returns (uint) {
        require(_gameId < gameList.length);
        require(gameList[_gameId].gameState == 2);
        require(gameList[_gameId].player1 == msg.sender || gameList[_gameId].player2 == msg.sender);
        require(gameList[_gameId].board[x][y] == 0);

        Game memory game = gameList[_gameId];

        game.board[x][y] = _playerNumber;
        game.stepsPlayed++;

        if (game.stepsPlayed == 9) {
            game.gameState = 3;
            game.winner = 0;
        } else {
            game.turn = 3 - game.turn;
        }

        emit GameStep(game.gameId, _playerNumber, x, y, game.stepsPlayed);

        return game.gameId;

    }


    function quitGame(uint _gameId) public returns (uint) {
        require(_gameId < gameList.length);
        require(gameList[_gameId].gameState == 2);
        require(gameList[_gameId].player1 == msg.sender || gameList[_gameId].player2 == msg.sender);

        Game memory game = gameList[_gameId];

        game.gameState = 3;
        game.winner = 0;

        emit GameFinished(game.gameId, game.winner, game.stepsPlayed);

        return game.gameId;
    }




    // fallback
    fallback() external payable {
        revert("Don't send money here");
    }

}