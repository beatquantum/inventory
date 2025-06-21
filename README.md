# Quantum Cryptographic Inventory Tool

A simple two-step approach to generate a cryptographic inventory and receive suggestions for your post-quantum journey. Designed to run on a variety of Linux servers.

## Overview

This tool provides an experimental set of bash scripts (version 1.0) and a prompt (version 1.0) to help you create a cryptographic inventory and analyze it using AI. Suggestions for improvements are always welcome!

## Prerequisites

- A Linux server with `git` installed.
- Access to an AI platform (e.g., Grok) in a secure browsing mode (Ghost, Incognito, or Private).
- Basic familiarity with terminal commands.

## Installation and Usage

### First-Time Installation

If you have already cloned the repository, skip to step 5.

1. Clone the repository:
   ```bash
   git clone https://github.com/beatquantum/inventory
   ```

2. Navigate to the repository directory:
   ```bash
   cd inventory
   ```

3. Save the prompt content to a notepad or text file for later use.

4. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

### Generate Baseline Inventory

5. Run the master script to generate the inventory:
   ```bash
   ./crypto_inventory_master.sh
   ```

6. Copy the generated inventory file to a secure location for upload:
   ```bash
   cp /var/log/inventory.txt /path/to/secure/location
   ```

### Analyze Using AI

7. Open your preferred AI platform (e.g., Grok) in **Ghost, Incognito, or Private mode** to ensure privacy.

8. (Optional) Enable **DeepSearch** or **Think mode** if supported by your AI platform for enhanced analysis.

9. Upload the `inventory.txt` file to the AI platform.

10. Paste the prompt you saved earlier into the AI interface.

## Expected Output

If everything runs smoothly, the AI will provide an analysis of your cryptographic inventory and suggestions for transitioning to Quantum-Safe Cryptography.

## Notes

- This is an experimental tool (version 1.0). Expect potential improvements in future releases.
- For issues or suggestions, please open an issue on the [GitHub repository](https://github.com/beatquantum/inventory).
- Always ensure secure handling of sensitive data, such as the `inventory.txt` file.

## Acknowledgments

Thank you for trying this tool! Feedback is appreciated.

— Santosh Pandit, June 21, 2025
