clear; clc; close all;

%% Compute x(t)
dt = 0.0025;
t = 0.001:dt:4;
size_t = size(t);
num_samples = size_t(2);
x = 1 * ((t <= 1) | ((t >= 3) & (t <= 4)));

T = 4;
w_0 = 2.*pi ./ T;

max_executions = floor((2.*pi ./ T) .* (1./dt)); % max frequency bin that can be fully represented in x(t)

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
    mserror(N) = mean((x - xhat).^2);
    
    % Plot every ten operations
    if(mod(N-1, 10) == 0)
        plot_xk_and_xhat(t, xhat, N, X_k)
    end
    if(mserror(N) < 0.001)
        break;
    end
    
    N = N + 1;
    if(N > max_executions)
        fprintf("Warning: N reached maximum; exiting loop\n");
        break;
    end
end

figure
plot(t, x, 'LineWidth', 5)
figure
plot(1:N, mserror, '.', 'MarkerSize', 20)

fprintf("Min error = %3.8f%%\n", min(mserror) * 100);
