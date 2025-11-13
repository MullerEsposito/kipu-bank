import { expect } from "chai";
import hre from "hardhat";

let ethers: any;
let kipuBank: any;

before(async () => {
  ({ ethers } = await hre.network.connect())
});

beforeEach(async () => {
  const kipuBankFactory = await ethers.getContractFactory("KipuBank");
  kipuBank = await kipuBankFactory.deploy(50, 100);

  await kipuBank.waitForDeployment();
})

describe("KipuBank", () => {
  describe("deposit", () => {
    it("should be possible to deposit", async () => {
      const [owner] = await ethers.getSigners();
      await expect(
        kipuBank.deposit({ value: 50n })
      ).to.emit(kipuBank, "Deposited").withArgs(owner.address, 50n);

      const kipuBankBalance = await ethers.provider.getBalance(await kipuBank.getAddress());

      expect(kipuBankBalance).to.equal(50n);
      expect(await kipuBank.depositCount(owner.address)).to.equal(1);
    })

    it("should not be possible to deposit a zero amount", async () => {
      await expect(
      kipuBank.deposit({ value: 0n })
    ).to.be.revertedWithCustomError(kipuBank, "InvalidAmount");
  })

  it("should not be possible to deposit more than the bank cap", async () => {
    await expect(
      kipuBank.deposit({ value: 101n })
    ).to.be.revertedWithCustomError(kipuBank, "BankCapExceeded");
  })
})

describe("withdraw", () => {
  it("should be possible to withdraw", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });
    await expect(
      kipuBank.withdraw(50n)
    ).to.emit(kipuBank, "Withdrawn").withArgs(owner.address, 50n);

    const kipuBankBalance = await ethers.provider.getBalance(await kipuBank.getAddress());

    expect(kipuBankBalance).to.equal(0n);
    expect(await kipuBank.depositCount(owner.address)).to.equal(1);
    expect(await kipuBank.withdrawCount(owner.address)).to.equal(1);
  })

  it("should not be possible to withdraw a zero amount", async () => {
    await expect(
      kipuBank.withdraw(0n)
    ).to.be.revertedWithCustomError(kipuBank, "InvalidAmount");
  })

  it("should not be possible to withdraw more than the limit", async () => {
    await kipuBank.deposit({ value: 60n });
    await expect(
      kipuBank.withdraw(51n)
    ).to.be.revertedWithCustomError(kipuBank, "WithdrawLimitExceeded");
  })

  it("should not be possible to withdraw more than the balance", async () => {
    await expect(
      kipuBank.withdraw(101n)
    ).to.be.revertedWithCustomError(kipuBank, "InsufficientBalance");
  })

  it("should be possible to count deposits and withdrawals", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });
    await kipuBank.deposit({ value: 50n });
    await kipuBank.withdraw(50n);
    await kipuBank.withdraw(20n);
    await kipuBank.withdraw(30n);

    expect(await kipuBank.depositCount(owner.address)).to.equal(2);
    expect(await kipuBank.withdrawCount(owner.address)).to.equal(3);
  })
})

describe("states", () => {
  it("should be possible to get the balance of the caller", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });

    expect(await kipuBank.getBalance()).to.equal(50n);
  })

  it("should be possible to get the balance of a specific address", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });

    expect(await kipuBank.getBalanceOf(owner.address)).to.equal(50n);
  })

  it("should be possible to get the deposit count", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });

    expect(await kipuBank.depositCount(owner.address)).to.equal(1);
  })

  it("should be possible to get the withdrawal count", async () => {
    const [owner] = await ethers.getSigners();

    await kipuBank.deposit({ value: 50n });
    await kipuBank.withdraw(50n);

    expect(await kipuBank.withdrawCount(owner.address)).to.equal(1);
  })
})
})
