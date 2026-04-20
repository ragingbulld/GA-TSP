function instance = LoadTSPLIBInstance(filePath)
%% 读取 TSPLIB TSP 文件
% 输出字段：name, dimension, edgeWeightType, coords

fid = fopen(filePath, 'r');
if fid == -1
    error('无法打开 TSPLIB 文件: %s', filePath);
end

cleaner = onCleanup(@() fclose(fid));

instance = struct('name', '', 'dimension', 0, 'edgeWeightType', '', 'coords', []);
coords = [];
inCoordSection = false;

while true
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end

    line = strtrim(line);
    if isempty(line)
        continue;
    end

    if strcmpi(line, 'NODE_COORD_SECTION')
        inCoordSection = true;
        continue;
    end

    if strcmpi(line, 'EOF')
        break;
    end

    if inCoordSection
        values = sscanf(line, '%f');
        if numel(values) >= 3
            coords(end + 1, :) = values(2:3)'; %#ok<AGROW>
        end
        continue;
    end

    parts = strsplit(line, ':');
    if numel(parts) < 2
        continue;
    end

    key = strtrim(parts{1});
    value = strtrim(strjoin(parts(2:end), ':'));

    switch upper(key)
        case 'NAME'
            instance.name = value;
        case 'DIMENSION'
            instance.dimension = str2double(value);
        case 'EDGE_WEIGHT_TYPE'
            instance.edgeWeightType = upper(value);
    end
end

instance.coords = coords;

if instance.dimension ~= size(coords, 1)
    error('TSPLIB 维度与坐标数不一致: dimension=%d, coords=%d', instance.dimension, size(coords, 1));
end
