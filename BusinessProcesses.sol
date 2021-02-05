// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./Owned.sol";

/**
 * @title Business process management
 * @author Lukyantsev Dmitry
 * @notice Managing business process, roles and actions
 */
abstract contract BusinessProcesses is Owned {
    /// @notice Business processes
    /// @dev Key is business process id
    mapping(uint => string) public bps;
    
    /// @notice Roles
    /// @dev Key is role id
    mapping(uint => string) public roles;
    
    /// @notice Actions
    /// @dev Key is action id
    mapping(uint => string) public actions;
    
    /// @notice One role can have several actions in the given business process
    /// @dev Mapping bpId => roleId => actionId => true
    /// @dev First key is business process id
    /// @dev Second key is role id
    /// @dev Third key is action
    /// @dev Result is true if the role has an action.
    mapping(uint => mapping(uint => mapping(uint => bool))) public roleActions;

    /// @notice Logging for new business process
    event AddBPEvent(uint bpId, string bpName);
    /// @notice Logging for new role
    event AddRoleEvent(uint roleId, string roleName);
    /// @notice Logging for new action
    event AddActionEvent(uint actionId, string actionName);

    /**
    * @notice Adding new business process
    * @param id Business process id
    * @param name Business process name
    * @return success True if BP was added, false if one is exists
    */
    function addBP(uint id, string memory name) 
        public
        onlyOwner
        returns (bool success)
    {
        if (bytes(bps[id]).length > 0)
            return false;
        else {
            bps[id] = name;
            emit AddBPEvent(id, name);
            return true;
        }
    }

    /**
    * @notice Adding new role
    * @param id Role id
    * @param name Role name
    * @return success True if role was added, false if one is exists
    */
    function addRole(uint id, string memory name) 
        public
        onlyOwner
        returns (bool success)
    {
        if (bytes(roles[id]).length > 0)
            return false;
        else {
            roles[id] = name;
            emit AddRoleEvent(id, name);
            return true;
        }
    }

    /**
    * @notice Adding new action
    * @param id Action id
    * @param name Action name
    * @return success True if action was added, false if one is exists
    */
    function addAction(uint id, string memory name) 
        public
        onlyOwner
        returns (bool success)
    {
        if (bytes(actions[id]).length > 0)
            return false;
        else {
            actions[id] = name;
            emit AddActionEvent(id, name);
            return true;
        }
    }

    /**
    * @notice Assigning action to role in business process
    * @param bpId Business process id
    * @param roleId Role id
    * @param actionId Action id
    * @return success True: action's role was set into bp, false: one is exists
    */
    function addRoleAction(uint bpId, uint roleId, uint actionId)
        public
        onlyOwner
        returns (bool success)
    {
        validateBP(bpId);
        validateRole(roleId);
        validateAction(actionId);
        // Если действие у роли?
        if (roleActions[bpId][roleId][actionId])
            return false;
        // Назначим действие роли
        roleActions[bpId][roleId][actionId] = true;
            return true;
    }

    /// @notice Checking whether business process is registered
    /// @param bpId Business process id
    function validateBP(uint bpId) internal view {
        require(
            bytes(bps[bpId]).length > 0, 
            unicode"Бизнес процесс не существует"
        );
    }
    
    /// @notice Checking whether role is registered
    /// @param roleId Role id
    function validateRole(uint roleId) internal view {
        require(
            bytes(roles[roleId]).length > 0, 
            unicode"Роль не существует"
        );
    }

    /// @notice Checking whether action is registered
    /// @param actionId Action id
    function validateAction(uint actionId) internal view {
        require(
            bytes(actions[actionId]).length > 0, 
            unicode"Действие роли не существует"
        );
    }
    
}
