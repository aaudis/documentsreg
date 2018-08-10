class Document < ApplicationRecord
    attr_accessor :file

    after_save :save_files, if: :file

    def save_files
        allfilenames   = []
        folder         = "public/documents/#{id}/"

        FileUtils::mkdir_p folder

        file.each do |item|
            filename = item.original_filename
            allfilenames.push(filename)
            
            f = File.open File.join(folder, filename), "wb"
            f.write item.read()
            f.close
        end

        self.file = nil
        update files: allfilenames.join(",")
    end
end
