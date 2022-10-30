const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    // added object for passing currency
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();
  console.log("Contract addy:", waveContract.address);

  // get contract balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  // send wave
  // let waveTxn = await waveContract.wave("A message")
  // await waveTxn.wait();

  //try to waves now
  const waveTxn = await waveContract.wave("This wave 1");
  await waveTxn.wait()
  const waveTxn2 = await waveContract.wave("This wave 2");
  await waveTxn2.wait()

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:",
  hre.ethers.utils.formatEther(contractBalance)
  );


  let allWave = await waveContract.getAllWaves();
  console.log(allWave);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();