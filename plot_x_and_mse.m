function [] = plot_x_and_mse(t, x, N, mse)
    figure
    plot(t, x, 'LineWidth', 5)
    title('Original function $$x(t)$$', 'Interpreter','Latex');
    ylabel('$$x(t)$$', 'Interpreter','Latex');
    xlabel('$$t$$ (time)', 'Interpreter','Latex');
    figure
    plot(1:N, mse .* 100, '.', 'MarkerSize', 30)
    title('Mean Squared Error of $$\hat{x}(t)$$ to $$x(t)$$', 'Interpreter','Latex');
    ylabel('$$MSE(N)$$ (percent of 100)', 'Interpreter','Latex');
    xlabel('$$N$$ (total bins)', 'Interpreter','Latex');
