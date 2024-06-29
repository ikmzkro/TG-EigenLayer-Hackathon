import { ethers } from "ethers";
import * as dotenv from "dotenv";
import { delegationABI } from "./abis/delegationABI";
import { contractABI } from './abis/contractABI';
import { registryABI } from './abis/registryABI';
import { avsDirectoryABI } from './abis/avsDirectoryABI';
import { helloWorld} from './wasm/assembly/index';
dotenv.config();

const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

const delegationManagerAddress = process.env.DELEGATION_MANAGER_ADDRESS!;
const contractAddress = process.env.CONTRACT_ADDRESS!;
const stakeRegistryAddress = process.env.STAKE_REGISTRY_ADDRESS!;
const avsDirectoryAddress = process.env.AVS_DIRECTORY_ADDRESS!;

const delegationManager = new ethers.Contract(delegationManagerAddress, delegationABI, wallet);
const contract = new ethers.Contract(contractAddress, contractABI, wallet);
const registryContract = new ethers.Contract(stakeRegistryAddress, registryABI, wallet);
const avsDirectory = new ethers.Contract(avsDirectoryAddress, avsDirectoryABI, wallet);

const signAndRespondToTask = async (taskIndex: number, taskCreatedBlock: number, taskName: string) => {
    const message = `Hello, ${taskName}`;
    const messageHash = ethers.utils.solidityKeccak256(["string"], [message]);
    const messageBytes = ethers.utils.arrayify(messageHash);
    const signature = await wallet.signMessage(messageBytes);

    console.log(
        `Signing and responding to task ${taskIndex}`
    )

    const tx = await contract.respondToTask(
        { name: taskName, taskCreatedBlock: taskCreatedBlock },
        taskIndex,
        signature
    );
    await tx.wait();
    console.log(`Responded to "${taskName}".`);
};

const registerOperator = async () => {
    const earningsReceiver = await wallet.address
    const delegationApproverAddress = await delegationManager.delegationApprover(earningsReceiver);
    try {
      const tx1 = await delegationManager.registerAsOperator({
        earningsReceiver: earningsReceiver,
        delegationApprover: delegationApproverAddress,
        stakerOptOutWindowBlocks: 0
      }, {
        gasLimit: "300000 "
      });
      await tx1.wait();
      console.log("Operator registered on EigenLayer successfully");
    } catch (error) {
      console.log('error', error);
    }

    const salt = ethers.utils.hexlify(ethers.utils.randomBytes(32));
    const expiry = Math.floor(Date.now() / 1000) + 3600; // Example expiry, 1 hour from now

    // Define the output structure
    let operatorSignature = {
        expiry: expiry,
        salt: salt,
        signature: ""
    };

    // Calculate the digest hash using the avsDirectory's method
    const digestHash = await avsDirectory.calculateOperatorAVSRegistrationDigestHash(
        wallet.address, 
        contract.address, 
        salt, 
        expiry
    );

    // Sign the digest hash with the "operator's private key"
    // The operator's private key needs to maintain sufficient assets.
    const signingKey = new ethers.utils.SigningKey(process.env.PRIVATE_KEY!);
    const signature = signingKey.signDigest(digestHash);
    
    // Encode the signature in the required format
    operatorSignature.signature = ethers.utils.joinSignature(signature);

    const tx2 = await registryContract.registerOperatorWithSignature(
        wallet.address,
        operatorSignature
    );
    await tx2.wait();
    console.log("Operator registered on AVS successfully");
};

const monitorNewTasks = async () => {
    // Here is WasmContract Trigger
    // Execute the contract to emit an event and create an event where Pikachu appears.
    await contract.createNewTask("Go!Pikachu!");

    // Detect that the event has been emitted in the contract, and the Operator signs the event.
    contract.on("NewTaskCreated", async (taskIndex: number, task: any) => {
        console.log(`New task detected: Hello, ${task.name}`);
        await signAndRespondToTask(taskIndex, task.taskCreatedBlock, task.name);
        // Execute the WASM to summon Pikachu.
        const monster = helloWorld();
        console.log('Pika Pika!', monster);
    });

    console.log("Monitoring for new tasks...");
};

const main = async () => {
  try {
    // Registering an Operator on EigenLayer and AVS:
    await registerOperator();

    // Start monitoring new tasks
    await monitorNewTasks();
  } catch (error) {
      console.error("Main function error:", error);
  }
};

main().catch((error) => {
    console.error("Error in main function:", error);
});