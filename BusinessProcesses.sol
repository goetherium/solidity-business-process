// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./Organizations.sol";

/**
 * @title Business process management
 * @author Lukyantsev Dmitry
 * @notice Managing business process, roles and actions
 */
abstract contract BusinessProcesses is Organizations {
    /// @notice Business processes
    /// @dev Key is business process id
    mapping(uint => string) public bps;
    
    /// @notice Roles
    /// @dev Key is role id
    mapping(uint => string) public roles;
    
    /// @notice Actions
    /// @dev Key is action id
    mapping(uint => string) public actions;
    
    /// @notice Employee can have only one role in the given business process
    /// @dev Mapping bpId => emplId
    /// @dev First key is business process id
    /// @dev Second key is employee id
    /// @dev Result is role id
    mapping(uint => mapping(uint => uint)) public emplRoles;
    
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
    * @notice Assigning role to employee in business process
    * @param bpId Business process id
    * @param emplId Employee id
    * @param roleId Role id
    * @return success True: employee's role was set into bp, false: one is exists
    */
    function addEmplRole(uint bpId, uint emplId, uint roleId)
        public
        onlyOwner
        returns (bool success)
    {
        validateEmployee(emplId);
        validateBP(bpId);
        validateRole(roleId);

        // Проверим наличие роли у сотрудника
        if (emplRoles[bpId][emplId] > 0)
            return false;
        else {
            emplRoles[bpId][emplId] = roleId;
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
            "The business process is not exists"
        );
    }
    
    /// @notice Checking whether role is registered
    /// @param roleId Role id
    function validateRole(uint roleId) internal view {
        require(
            bytes(roles[roleId]).length > 0, 
            "The role is not exists"
        );
    }

    /// @notice Checking whether action is registered
    /// @param actionId Action id
    function validateAction(uint actionId) internal view {
        require(
            bytes(actions[actionId]).length > 0, 
            "The action is not exists"
        );
    }
    
    // Для отладки
    //event CheckEmplActionEvent(uint bpId, uint emplId, uint actionId);
    //event EmplRoleEvent(uint roleId);

    /**
    * @notice Checking whether an employee can perform an action
    * @param bpId Business process id
    * @param emplId Employee id
    * @param actionId Action id
    * @return success True if employee has a role for given action
    */
    function checkEmplAction(
        uint bpId,
        uint emplId,
        uint actionId
    )
        internal
        view
        returns (bool success)
    {
        uint roleId;  // Роль сотрудника

        // Проверим наличие роли у сотрудника
        roleId = emplRoles[bpId][emplId];

        // Для отладки
        //emit CheckEmplActionEvent(bpId, emplId, actionId);
        //emit EmplRoleEvent(roleId);

        if (roleId == 0) 
            return false;

        // Действие доступно для роли сотрудника?
        if (roleActions[bpId][roleId][actionId]) 
            return true;
        else 
            return false;
    }
}
