clear; clc; close all;
plot_reducer = 1;

%% Compute x(t)
dt = 0.005;
t = 0.001:dt:2;
num_samples = size(t, 2);
x = zeros(size(t));

for time = 1:num_samples
    if(t(time) >= 0 && t(time) <= 1)
        x(time) = t(time);
    elseif(t(time) > 1 && t(time) <= 2)
        x(time) = 2 - t(time);
    end
end

T = 2;
w_0 = 2.*pi ./ T;

 % max frequency bins that can be fully represented in x(t)
max_executions = floor((2.*pi ./ T) .* (1./dt) / 2);

%mserror = zeros(1, max_executions);

xhat_freq_components(num_samples, max_executions) = 0;

%% Compute DFT Error For N from 1 to executions
N = 1;
% Compute Fourier Series (xhat)
while 1
    % Find reconstructed signal
    %xhat(N) = zeros(1, num_samples);
    for k = -N:N
        k_indx = k+N+1;
        % DFT
        X_k(k_indx) = (1./T) .* sum(dt .* x .* (exp(1) .^ (-1j .* k .* w_0 .* t)));
        
        % Reconstructed value in broken up frequencies
        xhat_freq_components(:, k_indx) = (X_k(k_indx) .* (exp(1) .^ (1j .* k .* w_0 .* t)));
        
    end
    
    % Combine all frequencies
    xhat = zeros(1, num_samples);
    for time = 1:num_samples
        xhat(time) = real(sum(xhat_freq_components(time, :)));
    end
    
    % Check error
    mserror(N) = mean((x - xhat).^2);
    
    % Plot every couple of operations
    if(N <= 5 || N ==  1 * plot_reducer || N ==  3 * plot_reducer)
        plot_xk_and_xhat(t, xhat, N, X_k)
        if(N ==  3 * plot_reducer)
            plot_reducer = plot_reducer * 10;
        end
    end

    % Exit the loop when appropriate
    if(mserror(N) < 0.0000001)
        break;
    end
    
    N = N + 1;
    if(N > max_executions)
        fprintf("Warning: N reached maximum; exiting loop\n");
        break;
    end
end

plot_x_and_mse(t, x, N, mserror)

fprintf("Min error = %3.8f%%\n", min(mserror) * 100);
