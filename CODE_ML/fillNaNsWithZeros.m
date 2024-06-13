function data = fillNaNsWithZeros(data)
    % Replace NaN values with zeros
    data(isnan(data)) = 0;
end
