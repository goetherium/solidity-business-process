// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./Owned.sol";

/**
 * @title Organizations and employees management
 * @author Lukyantsev Dmitry
 */
abstract contract Organizations is Owned {
    /// @dev Type for organizations
    struct Organization{
        string name;
        string desc;
    }
    /// @notice Organizations, key is organization id
    mapping(uint => Organization) public orgs;
    
    /// @dev Type for employees
    struct Employee {
        uint orgId;
        string fio;
        string email;
    }
    /// @notice Employees, key is employee id
    mapping(uint => Employee) public empls;

    /// @notice Logging for new organization
    /// @param orgId Organization id
    /// @param orgName Organization name
    event AddOrgEvent(uint orgId, string orgName);

    /// @notice Logging for new employee
    /// @param emplId Employee id
    /// @param orgId Organization id
    /// @param fio Employee fio
    event AddEmplEvent(uint emplId, uint orgId, string fio);
  
    /**
    * @notice Adding new organization
    * @param id Organization id
    * @param name Organization name
    * @param desc Organization description
    * @return success True if organization was added, false if one is exists
    */
    function addOrg(uint id, string memory name, string memory desc)
        public
        onlyOwner
        returns (bool success) 
    {
        if (bytes(orgs[id].name).length > 0)
            return false;
        else {
            orgs[id].name = name;
            orgs[id].desc = desc;
            emit AddOrgEvent(id, name);
            return true;
        }
    }

    /**
    * @notice Adding new employee in organization
    * @param emplId employee id
    * @param orgId Organization id
    * @param fio Employee fio
    * @param email Employee email
    * @return success True if employee was added, false if one is exists
    */
    function addEmpl(
        uint emplId,
        uint orgId, 
        string memory fio,
        string memory email
    )
        public
        onlyOwner
        returns (bool success) 
    {
        if (bytes(empls[emplId].fio).length > 0)
            return false;
        else {
            empls[emplId].orgId = orgId;
            empls[emplId].fio = fio;
            empls[emplId].email = email;
            emit AddEmplEvent(emplId, orgId, fio);
            return true;
        }
    }

    /// @notice Check for existing organization
    function validateOrg(uint orgId) internal view {
        require(
            bytes(orgs[orgId].name).length > 0, 
            unicode"Организация не существует"
        );
    }
    
    /// @notice Check for existing employee
    function validateEmployee(uint emplId) internal view {
        require(
            bytes(empls[emplId].fio).length > 0, 
            unicode"Сотрудник не существует"
        );
    }
}
