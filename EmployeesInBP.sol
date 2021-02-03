// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./Organizations.sol";
import "./BusinessProcesses.sol";

/**
 * @title Employees in business process management
 * @author Lukyantsev Dmitry
 */
abstract contract EmployeesInBP is Organizations, BusinessProcesses {
    /// @notice Employee can have only one role in the given business process
    /// @dev Mapping bpId => emplId
    /// @dev First key is business process id
    /// @dev Second key is employee id
    /// @dev Result is role id
    mapping(uint => mapping(uint => uint)) public emplRoles;
    
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
        if (roleId == 0) 
            return false;
        // Действие доступно для роли сотрудника?
        if (roleActions[bpId][roleId][actionId]) 
            return true;
        else 
            return false;
    }
}
