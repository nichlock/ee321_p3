clear; clc; close all;

%% Compute x(t)
dt = 0.01;
t = .001:dt:4;
size_t = size(t);
num_samples = size_t(2);
x = 1 + (.25 * cos(2*pi*.25*t) + (.5 * sin(2*pi*.25*2*t)));

T = 4;
w_0 = 2.*pi ./ T;


executions = 4;

mse =  zeros(1, executions);
%% Compute DFT Error For N from 1 to executions

% Compute Fourier Series (xhat)
for N = 1:executions
    
    % Find reconstructed signal
    %xhat(N) = zeros(1, num_samples);
    X_k = zeros(1, 2.*N + 1);
    xhat_freq_components(num_samples, 2.*N + 1) = 0;
    for k = -N:N
        k_indx = k+N+1;
        % Build X_k for this frequincy bin
        if((k == 2))
            X_k(k_indx) = 1 ./ (2j);
        elseif((k == -2))
            X_k(k_indx) = 1 ./ (-2j);
        elseif((k == 1) || (k == -1))
            X_k(k_indx) = 1 ./ (4);
        elseif((k == 0))
            X_k(k_indx) = 1;
        else
            X_k(k_indx) = 0;
        end
 
        % Reconstructed value in broken up frequencies
        for time = 1:num_samples
            xhat_freq_components(time, k_indx) = (X_k(k_indx) .* (exp(1) .^ (1j .* k .* w_0 .* t(time))));
        end
    end
    
    % Combine all frequencies
    xhat = zeros(size_t);
    for time = 1:num_samples
        xhat(time) = (sum(xhat_freq_components(time, (N+1):(N * 2+1))));
    end
    
    % Check error
    mse(N) = mean((x - real(xhat)).^2);
    
    
    plot_xk_and_xhat(t, xhat, N, X_k)
    
end

figure
plot(t, x, 'LineWidth', 5)
figure
plot(-executions:executions, abs(X_k), 'LineWidth', 5)
figure
plot(1:executions, abs(mse), '.', 'MarkerSize', 20)

fprintf("Min error = %3.2f%%\n", min(mse) * 100);
