// SPDX-License-Identifier: MIT
import "./token/ERC20.sol";
import "./access/Ownable.sol";

pragma solidity ^0.8.0;

contract StakingToken is Ownable, ERC20{
    /**
        * @notice We should have the name of our token
     */
    string public _name = "ERC20 Token";

    /**
        * @notice We should have the symbol of our token
     */
     
     string public _symbol = "E20";
    /**
        * @notice We need to know the stakeholders
     */
     address[] private stakeholders;

    /**
        * @notice We need to know the stakes of each stakeholder
     */
     mapping(address => uint256) internal stakes;

     /**
        * @notice The accumulated reward for each stakeholder
      */
     mapping(address => uint256) internal reward;

     /**
        * @notice the last time a stakeholder was rewarded
      */
      mapping (address => uint256) internal lastUpdate;
      
        mapping (address => uint256) userRewardPerTokenPaid;
        mapping (address => uint256) balances;
      /**
        * @notice reward rate
       */
        uint256 internal rewardRate = 100;

    /**
     * @notice The constructor for the Staking Token.
     * @param _owner The address to receive all tokens on construction.
     * @param _supply The amount of tokens to mint on construction.
     */
    constructor(address _owner, uint256 _supply) ERC20(_name, _symbol)
    { 
        _mint(_owner, _supply);
    }

    // ----------- Stakes --------------

    /**
        @notice The create stake function allows a stakeholder to create tokens.
        @param _stake The amount of tokens to stake.
     */

     function createStake(uint256 _stake) public updateReward(msg.sender, stakes[msg.sender]){
         _burn(msg.sender, _stake);
         // check if the stakeholder has stakes already
         if (stakes[msg.sender] == 0) addStakeholder(msg.sender);
         stakes[msg.sender] += _stake;
     }

     /**
        @notice The delete stake function allows a stakeholder to delete tokens.
        @param _stake the amount of stakes to be returned.
      */
      function deleteStake(uint256 _stake) public updateReward(msg.sender, stakes[msg.sender]){
          (bool _isStakeholder,) = isStakeholder(msg.sender);
          require(_isStakeholder == true, "Only stakeholders can delete stakes.");
          require(stakes[msg.sender] >= _stake, "You do not have enough stakes to delete.");
          if(stakes[msg.sender] == _stake) {
              _mint(msg.sender, _stake);
              removeStakeholder(msg.sender);
              
          } else {
          _mint(msg.sender, _stake);
          stakes[msg.sender] -= _stake;
        }
      }

      /**
         @notice The stake of function will return the stake of the stakeholder.
         @param _stakeholder The address of the stakeholder.
         @return uint256 The stake of the stakeholder.
      */
      function stakeOf(address _stakeholder) public view returns (uint256) {
          return stakes[_stakeholder];
      }
        /**
        * @notice A method to the aggregated stakes from all stakeholders.
        * @return uint256 The aggregated stakes from all stakeholders.
        */
        function totalStakes() public view returns(uint256)
        {
            uint256 _totalStakes = 0;
            for (uint256 s = 0; s < stakeholders.length; s += 1){
                _totalStakes = _totalStakes + stakes[stakeholders[s]];
            }
            return _totalStakes;
        }


        // ------------------- Stakeholders --------------

        /**
         * @notice The add stakeholder function allows a stakeholder to be added to the list of stakeholders.
         * @param _stakeholder The address of the stakeholder.
         */
         function addStakeholder(address _stakeholder) public {
             (bool _isStakeholder,) = isStakeholder(_stakeholder);
             require(_isStakeholder == false, "Stakeholder already exists.");
             stakeholders.push(_stakeholder);
         }

         /**
          * @notice The is stakeholder function will return true if the address is a stakeholder.
          * @param _stakeholder The address of the stakeholder.
          * @return bool, uint256 if the address is a stakeholder.
          */
          function isStakeholder(address _stakeholder) public view returns (bool, uint256) {
              for (uint256 s = 0; s < stakeholders.length; s +=1){
                    if (stakeholders[s] == _stakeholder) return (true, s);
              }
              return (false, 0);
          }
          /**
            @notice The remove stakeholder function allows a stakeholder to be removed from the list of stakeholders.
            @param _stakeholder The address of the stakeholder.
           */
           function removeStakeholder(address _stakeholder) public {
               (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
               require(_isStakeholder == true, "Stakeholder does not exist.");
               stakeholders[s] = stakeholders[stakeholders.length - 1];
               stakeholders.pop();
           }
            function returnStakeHolders() public view returns (address[] memory) {
                return stakeholders;
            }
              // ------------------- Rewards -------------- 
            
            modifier updateReward(address _stakeholder, uint256 _stake){
                _;
                reward[_stakeholder] += rewardPerStake(_stakeholder) + _stake/100;
                lastUpdate[_stakeholder] = block.timestamp;
            }
            /**
            @notice This reward per token returns the reward per token.
            @return uint256 The reward per token.
             */
             function rewardPerStake(address _stakeholder) public view returns (uint256) {
               if (stakes[_stakeholder] == 0) return 0;
               uint256 _reward = (block.timestamp - lastUpdate[_stakeholder]) * stakes[_stakeholder] / rewardRate;
               return _reward;
             }

             function returnReward(address _stakeholder) public view returns (uint256) {
                return reward[_stakeholder];
             }

             function getReward(address _stakeholder) public {
                uint256 _reward = reward[_stakeholder];
                reward[_stakeholder] = 0;
                _mint(_stakeholder, _reward);
             }
             
}

