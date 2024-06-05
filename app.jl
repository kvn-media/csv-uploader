using GenieFramework, DataFrames, CSV, PlotlyBase
@genietools


const FILE_PATH = joinpath("public", "uploads")
mkpath(FILE_PATH)
@app begin
    @out upfiles = readdir(FILE_PATH)
    @onchange fileuploads begin
        if ! isempty(fileuploads)
            @info "File was uploaded: " fileuploads
            filename = fileuploads["name"]

            try
                isdir(FILE_PATH) || mkpath(FILE_PATH)
                mv(fileuploads["path"], joinpath(FILE_PATH, filename), force=true)
            catch e
                @error "Error processing file: $e"
                notify(__model__,"Error processing file: $(fileuploads["name"])")
            end

            fileuploads = Dict{AbstractString,AbstractString}()
        end
        upfiles = readdir(FILE_PATH)
    end
    @event uploaded begin
        @info "uploaded"
        notify(__model__, "File was uploaded")
    end
    @event rejected begin
        @info "rejected"
        notify(__model__, "Please upload a valid file")
    end
end

@page("/", "ui.jl")