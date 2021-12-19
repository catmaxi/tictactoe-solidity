const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tictactoe contract", function () {

    let tictactoe_contract;
    let tictactoe;
    let accounts;


    beforeEach(async function () {

        accounts = await ethers.getSigners();

        tictactoe_contract = await ethers.getContractFactory("Tictactoe");

        tictactoe = await tictactoe_contract.deploy();

        await tictactoe.deployed();

    });

    describe("Deployment", function () {
        // `it` is another Mocha function. This is the one you use to define your
        // tests. It receives the test name, and a callback function.

        // If the callback function is async, Mocha will `await` it.
        it("Should set the right owner", async function () {
            // Expect receives a value, and wraps it in an Assertion object. These
            // objects have a lot of utility methods to assert values.

            // This test expects the owner variable stored in the contract to be equal
            // to our Signer's owner.
            expect(await tictactoe.owner()).to.equal(accounts[0].address);
        });
    });


    describe("Pre Game", function () {
        it("Should create a new game", async function () {
            await tictactoe.createNewGame();
            console.log((await tictactoe.gameList(0)).player1);
            expect(await tictactoe.getGameListLength()).to.equal(1);
        });
        
        it("Should create a new Game as Player 1", async function () {
            await tictactoe.connect(accounts[0]).createNewGame();
            // console.log(await tictactoe.gameList(0))
            expect((await tictactoe.gameList(0)).player1).to.equal(accounts[0].address);
        });
        
        it("Should Join a Game as Player 2", async function () {
            await tictactoe.createNewGame();
            await tictactoe.connect(accounts[1]).joinGame(0);
            expect((await tictactoe.gameList(0)).player2).to.equal(accounts[1].address);
        });

        it ("Should start the Game", async function () {

            await tictactoe.createNewGame();
            await tictactoe.connect(accounts[1]).joinGame(0);
            await tictactoe.connect(accounts[0]).startGame(0);
            expect((await tictactoe.gameList(0)).gameState).to.equal(2);
            expect((await tictactoe.gameList(0)).turn).to.equal(1);
        });
    });

    describe("Game", function () {

        beforeEach(async function () {
            await tictactoe.deployed();

            await tictactoe.createNewGame();
            await tictactoe.connect(accounts[1]).joinGame(0);
            await tictactoe.connect(accounts[0]).startGame(0);
        });


        it("Should let player 1 make a move", async function () {
            // console.log(await tictactoe.gameList(0));
            // console.log(await tictactoe.getBoard(0));
            await tictactoe.move(0, 1, 0, 0);
            
            // console.log(await tictactoe.gameList(0));
            // console.log(await tictactoe.getBoard(0));
            expect((await tictactoe.getBoard(0))[0][0]).to.equal(1);

            expect((await tictactoe.gameList(0)).turn).to.equal(2);
            expect((await tictactoe.gameList(0)).stepsPlayed).to.equal(1);

        });

        it("Should let player 2 make a move", async function () {
            await tictactoe.move(0, 1, 0, 0);
            await tictactoe.connect(accounts[1]).move(0, 2, 0, 1);
            
            expect((await tictactoe.getBoard(0))[0][1]).to.equal(2);

            expect((await tictactoe.gameList(0)).turn).to.equal(1);
            expect((await tictactoe.gameList(0)).stepsPlayed).to.equal(2);

        });

        it("Should let player 1 win", async function () {
            await tictactoe.move(0, 1, 0, 0);
            await tictactoe.connect(accounts[1]).move(0, 2, 0, 1);
            await tictactoe.connect(accounts[0]).move(0, 1, 1, 1);
            await tictactoe.connect(accounts[1]).move(0, 2, 0, 2);
            await tictactoe.connect(accounts[0]).move(0, 1, 2, 2);

            console.log(await tictactoe.gameList(0));
            console.log(await tictactoe.getBoard(0));

            expect((await tictactoe.gameList(0)).gameState).to.equal(4);
            expect((await tictactoe.gameList(0)).winner).to.equal(1);
        });
    });


});
