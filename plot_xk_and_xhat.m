function [] = plot_xk_and_xhat(t, xhat, N, X_k)
    % Gets magnitude accounting for imaginaries, without removing negatives
    X_k = (abs(X_k) .* (-1 .* (real(X_k) < 0))) + (abs(X_k) .* (real(X_k) >= 0));
    
    figure('NumberTitle', 'off', 'Name', 'This is the figure title');
    subplot(2,1,1)
    plot(t, real(xhat), 'LineWidth', 5)
    title(['Regenerated $$\hat{x}$$ with N = ', num2str(N)], 'Interpreter','Latex')
    ylabel('$$\hat{x}(t)$$', 'Interpreter','Latex')
    xlabel('time', 'Interpreter','Latex')
    ax = gca;
    ax.FontSize = 12;
    subplot(2,1,2)
    plot(-N:N, real(X_k), '.', 'MarkerSize', 20)
    ylabel('$$X_{k}(k)$$', 'Interpreter','Latex')
    xlabel('k (bin number)', 'Interpreter','Latex')
    ax = gca;
    ax.FontSize = 12;