# EigemWasm ⚡🇪🇼⚡
<div align="center">
  <img src="https://github.com/vitocchi/TG-EigenLayer-Hackathon/assets/38712518/6a581f0b-7834-4ce9-bd54-f2fdc9bf4aea" alt="Sample Image" width="50%">
</div>



## ⚡Introduction⚡
This project aims to create a general-purpose contract execution machine running on EigenLayer to address the challenges faced by the EVM, such as scalability limitations and high gas fees. WebAssembly is well-suited for this purpose due to its efficiency, security, and portability. These characteristics make it ideal for creating versatile and reliable contracts. Additionally, using Fault Proofs to pass contract execution costs to operators can significantly improve scalability.

## ⚡Features⚡

### WasmContract
WasmContract is a composable and interactive contract compiled to WebAssembly. It can be written in multiple languages such as Rust, Go, and AssemblyScript.

### WasmContract VM
Operators run a VM that executes composable and interactive contracts written in Wasm. This VM draws inspiration from projects like CosmWasm and other Wasm-based contract implementations.

### WasmContract Fault Proof
On Ethereum, there needs to be a Fault Proof Contract to verify that the execution results of the WasmContract VM by the operator are invalid. This concept is based on mechanisms like Cannon in Optimistic Rollups.

## ⚡Features Developed During the Hackathon⚡
During this hackathon, we developed a prototype of the WasmContract VM and created a flow scenario demonstrating the interaction between the AVS Consumer, WasmContract Trigger, and WasmContract VM.

In this scenario, the AVS Consumer calls the WasmContract Trigger, which then triggers the WasmContract VM.

The operator executes the Wasm code and returns the result.

## ⚡Usage⚡
1. Run `git clone https://github.com/Turingum-inc/EigenLayer-Hackathon.git && cd EigenLayer-Hackathon`
2. Run `yarn install`
3. Run `cp .env.anvil .env`
4. Run `make start-chain-with-contracts-deployed`
    * This will build the contracts, start an Anvil chain, deploy the contracts to it, and leaves the chain running in the current terminal
5. Open new terminal tab and run `make start-operator`
    * This will compile the AVS software and start monitering new tasks

## ⚡Demo⚡
![Demo Image](https://github.com/ikmzkro/TG-EigenLayer-Hackathon/assets/74099733/b9a1f283-0af4-420f-99f0-4d1185b3bbb3)
[Demo Video](https://github.com/ikmzkro/TG-EigenLayer-Hackathon/assets/74099733/ad99eac7-f3b6-4196-88f3-1056c67199b4)

<video controls src="demo.mp4" title="Title"></video>

## ⚡Architecture⚡
![mermaid-diagram-2024-06-29-212042](https://github.com/vitocchi/TG-EigenLayer-Hackathon/assets/38712518/7e8df86f-6d6a-4763-b639-08125cdd6a34)


## ⚡License⚡
This project is licensed under the MIT License.

## ⚡Contact⚡
Email: dev@turingum.com

Project Link: https://github.com/Turingum-inc/EigenLayer-Hackathon
