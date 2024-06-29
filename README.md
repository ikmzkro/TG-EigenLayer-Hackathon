# Project Title

## Introduction
This project was created to solve [problem description]. Specifically, it provides [brief solution overview].

## Features

### WasmContract
WasmContract is a composable and interactive contract compiled to WebAssembly. It can be written in multiple languages such as Rust, Go, and AssemblyScript.

### WasmContract VM
Operators run a VM that executes composable and interactive contracts written in Wasm. This VM draws inspiration from projects like CosmWasm and other Wasm-based contract implementations.

### WasmContract Fault Proof
On Ethereum, there needs to be a Fault Proof Contract to verify that the execution results of the WasmContract VM by the operator are invalid. This concept is based on mechanisms like Cannon in Optimistic Rollups.

## Features Developed During the Hackathon
During this hackathon, we developed a prototype of the WasmContract VM and created a flow scenario demonstrating the interaction between the AVS Consumer, WasmContract Trigger, and WasmContract VM.

In this scenario, the AVS Consumer calls the WasmContract Trigger, which then triggers the WasmContract VM.

The operator executes the Wasm code and returns the result.

## Demo
![Demo Image](link_to_screenshot)
[Demo Video](link_to_demo_video)


## Architecture
![mermaid-diagram-2024-06-29-212042](https://github.com/vitocchi/TG-EigenLayer-Hackathon/assets/38712518/7e8df86f-6d6a-4763-b639-08125cdd6a34)


## License
This project is licensed under the MIT License.

## Contact
Email: dev@turingum.com

Project Link: https://github.com/ikmzkro/TG-EigenLayer-Hackathon
