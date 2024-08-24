# w-connecting

**w-connecting** is a FiveM script designed to manage player connections to your Fivem server using Discord-based role verification. This script offers a queue management system with role-based priority, adaptive card display, and support for additional slots for admins.

## Features

- **Discord Role Verification**: Ensures players have the correct roles in your Discord server before allowing them to connect.
- **Queue System**: Manages player connections with a queue, displaying their position in real-time.
- **Priority System**: Admins and other roles can be given priority in the queue.
- **Reconnection Priority**: Players who reconnect are given higher priority in the queue.
- **Adaptive Cards**: Displays adaptive cards during the connection process with user-specific information.

## Requirements

- **FiveM Server**
- **Discord Bot** with a bot token and access to your server

## Installation

1. **Clone or download the repository:**

    ```bash
    git clone https://github.com/WrenchRB/w-connecting.git
    ```

2. **Place the `w-connecting` folder into your server's `resources` directory.**

3. **Add the resource to your `server.cfg`:**

    ```bash
    ensure w-connecting
    ```

4. **Configure the script:**
   
   - Open the `w-connecting.lua` file and configure the following:
     - `GuildID`: Your Discord server's ID.
     - `Token`: Your Discord bot's token.
     - `Roles`: The Discord role IDs that are allowed to connect.
     - `Roles2`: The Discord role IDs for admin roles with priority.
     - `ServerName`: Your server's name.

5. **Start your FiveM server.** The script will now manage player connections according to the roles configured.

## Configuration

Edit the `w-connecting.lua` file to match your server's settings. You can configure the role IDs, server name, and messages displayed to users during the connection process.

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request. Contributions are welcome!

## License

This project is licensed under the GNU General Public License (GNU) v3. See the [LICENSE](LICENSE) file for details.

---

*Created by WrenchRB*  
*GitHub: [WrenchRB](https://github.com/WrenchRB)*
*Discord: [Wrench Scripts](https://discord.gg/RBjWGACJzW)*
