clear; clc; close all;

%% Compute x(t)
dt = 0.01;
t = 0.001:dt:4;
size_t = size(t);
num_samples = size_t(2);
x = 1 * ((t <= 1) | ((t >= 3) & (t <= 4)));

T = 4;
w_0 = 2.*pi ./ T;


executions = 101;

mse =  zeros(1, executions);
%% Compute DFT Error For N from 1 to executions

% Compute Fourier Series (xhat)
for N = 1:executions
    
    % Find reconstructed signal
    %xhat(N) = zeros(1, num_samples);
    X_k = [];
    xhat_freq_components(num_samples, N) = 0;
    for k = -N:N
        k_indx = k+N+1;
        % DFT
        X_k(k_indx) = (1./T) .* sum(dt .* x .* (exp(1) .^ (-1j .* k .* w_0 .* t)));
        
        % Reconstructed value in broken up frequencies
        for time = 1:num_samples
            xhat_freq_components(time, k_indx) = (X_k(k_indx) .* (exp(1) .^ (1j .* k .* w_0 .* t(time))));
        end
        
    end
    
    % Combine all frequencies
    xhat = zeros(size_t);
    for time = 1:num_samples
        xhat(time) = real(sum(xhat_freq_components(time, :)));
    end
    
    % Check error
    mse(N) = mean((x - xhat).^2);
    
    % Plot every ten operations
    if(mod(N-1, 10) == 0)
        plot_xk_and_xhat(t, xhat, N, X_k)
    end
    
end

figure
plot(t, x, 'LineWidth', 5)
figure
plot(1:executions, mse, '.', 'MarkerSize', 20)

fprintf("Min error = %3.2f%%\n", min(mse) * 100);
