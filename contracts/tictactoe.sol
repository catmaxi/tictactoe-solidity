// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import '@openzeppelin/contracts/access/Ownable.sol';


contract Tictactoe {

    
    struct Game {
        // game Id (unique) increamenting from 0
        uint gameId;

        // 3x3 board with 0,1,2 for empty, X, O
        uint8[3][3] board;

        // 0 for X, 1 for O
        uint8 turn;

        // 0 for not finished, 1 for player 1 win, 2 for player 2 win, 3 for draw
        uint8 winner;

        // 0 for not started, 1 for joined, 2 for started, 3 for quit, 4 for finished
        uint8 gameState;

        // address of player 1
        address player1;

        // address of player 2
        address player2;

        // total number of moves played in the game
        uint stepsPlayed;
    }

    Game[] public gameList;


    event GameCreated(uint gameId);
    event GameJoined(uint gameId, address player, uint8 playerNumber);
    event GameStarted(uint gameId);
    event GameFinished(uint gameId, uint8 winner, uint stepsPlayed);
    event GameStep(uint gameId, uint8 playerNumber, uint8 x, uint8 y, uint step);


    constructor() {}

    function getGame(uint _gameId) public view returns (Game memory) {
        return gameList[_gameId];
    }


    function getBoard(uint _gameId) public view returns (uint8[3][3] memory) {
        return gameList[_gameId].board;
    }

    function getBoardItem(uint _gameId, uint8 _x, uint8 _y) public view returns (uint8) {
        return gameList[_gameId].board[_x][_y];
    }



    function getGamePlayerNumber(uint _gameId, address _player) public view returns (uint8 playerNumber) {
        Game memory game = gameList[_gameId];
        if (game.player1 == _player) {
            return 1;
        } else if (game.player2 == _player) {
            return 2;
        } else {
            revert("Player not found");
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
        game.turn = 1;

        emit GameStarted(game.gameId);

        return game.gameId;
    }

    


    // this has not been tested
    function checkWin(uint _gameId) public view returns (uint8 winner) {
        require(_gameId < gameList.length);
        // require(gameList[_gameId].gameState == 2);

        Game memory game = gameList[_gameId];
        uint8[3][3] memory board = game.board;

        // check rows
        if (board[0][0] == board[0][1] && board[0][1] == board[0][2]) return board[0][0];
        if (board[1][0] == board[1][1] && board[1][1] == board[1][2]) return board[1][0];
        if (board[2][0] == board[2][1] && board[2][1] == board[2][2]) return board[2][0];
    
        // check columns
        if (board[0][0] == board[1][0] && board[1][0] == board[2][0]) return board[0][0];
        if (board[0][1] == board[1][1] && board[1][1] == board[2][1]) return board[0][1];
        if (board[0][2] == board[1][2] && board[1][2] == board[2][2]) return board[0][2];
        
        // check diagonals
        if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) return board[0][0];  
        if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) return board[0][2];

        return 0;
    }


    // player number problem
    function move(uint _gameId, uint8 _playerNumber, uint8 x, uint8 y) public returns (uint) {
        require(_gameId < gameList.length);

        Game memory game = gameList[_gameId];

        require(game.gameState == 2);

        if (_playerNumber == 1) {
            require(game.player1 == msg.sender);
            require(game.turn == 1);
        } else if (_playerNumber == 2) {
            require(game.player2 == msg.sender);
            require(game.turn == 2);
        } else {
            revert("Player not found");
        }

        // require(gameList[_gameId].player1 == msg.sender || gameList[_gameId].player2 == msg.sender);

        require(gameList[_gameId].board[x][y] == 0);

        game.board[x][y] = _playerNumber;
        game.stepsPlayed++;

        emit GameStep(game.gameId, _playerNumber, x, y, game.stepsPlayed);

        uint8 winner = checkWin(_gameId);

        // if no winner, switch turn
        if (winner == 0) {
            game.turn = 3 - _playerNumber;

            if (game.stepsPlayed == 9) {
                game.gameState = 4;
                game.winner = 3;

                emit GameFinished(game.gameId, winner, game.stepsPlayed);
            }

        } else {
            game.winner = winner;
            game.gameState = 4;

            emit GameFinished(game.gameId, winner, game.stepsPlayed);
        }

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

    // receive ETH
    receive() external payable {
        revert("Don't send money here");
    }
}