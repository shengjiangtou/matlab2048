classdef Memory < handle
    properties
        limit;
        size;
        prestates;
        actions;
        rewards;
        poststates;
    end
    
    methods
        function this = Memory(limit, dims)
        % Memory Initialize memory.
        % Parameters:
        %  limit - memory maximum size
        %  dims - dimensions of states, e.g. [4 4]
        % Returns memory object.
        % Memory is kept as four matrices: prestates, actions, rewards and
        % poststates.

            this.size = 0;
            this.limit = limit;
            this.prestates = zeros([limit dims]);
            this.actions = zeros(limit, 1);
            this.rewards = zeros(limit, 1);
            this.poststates = zeros([limit dims]);
        end

        function add(this, prestate, action, reward, poststate)
        % ADD Add one state transition to memory.
        % Parameters:
        %  m - memory object
        %  prestate - state before (matrix)
        %  action - action taken in this state
        %  reward - observerd reward
        %  poststate - state after the action
        % Returns new memory object.

            % roll over to first if over limit
            this.size = this.size + 1;
            index = mod(this.size - 1, this.limit) + 1;
            % store state transition in memory at position index
            this.prestates(index, :, :) = prestate;
            this.actions(index) = action;
            this.rewards(index) = reward;
            this.poststates(index, :, :) = poststate;
        end

        function batch = minibatch(this, minibatch_size)
        % MEMORY_MINIBATCH Return minibatch from memory.
        % Parameters:
        %  m - memory object
        %  minibatch_size - size of the minibatch
        % Returns minibatch struct, containing four matrices: prestates, actions,
        % rewards and poststates.

            % find minibatch_size random indexes of memory
            indexes = randperm(min(this.size, this.limit), minibatch_size);
            % return values of those cells
            batch.prestates = this.prestates(indexes, :, :);
            batch.actions = this.actions(indexes);
            batch.rewards = this.rewards(indexes);
            batch.poststates = this.poststates(indexes, :, :);
        end
    end
end
