class Document < ApplicationRecord
    attr_accessor :file, :dellist

    validates :title, presence: true, length: { maximum: 255 }
    validates :content, presence: true

    after_save :save_files, if: :file
    before_save :update_del_list, if: :dellist
    after_destroy :delete_storage_folder

    # storage path
    def folderPath
        "public/documents/#{id}/"
    end

    # save uploaded files to storage
    def save_files
        allfilenames    = []
        stored_files    = self.files.nil? == false ? self.files.split(",") : [] 
    
        FileUtils::mkdir_p folderPath

        file.each do |item|
            filename = item.original_filename
            allfilenames.push(filename)
            
            f = File.open File.join(folderPath, filename), "wb"
            f.write item.read()
            f.close
        end

        self.file = nil
        stored_files.push(allfilenames)
        update files: stored_files.join(",")
    end

    # remove uploaded files from storage
    def update_del_list
        stored_files = self.files.split(",")

        dellist.each do |del|
            if stored_files.include? del 
                File.delete(folderPath + del) if File.exist?(folderPath + del)
                stored_files.delete(del)
            end
        end

        self.dellist = nil
        self.files = stored_files.join(",")

        # if storage directory is empty then delete it
        FileUtils.rm_rf(folderPath) if Dir[folderPath + "*"].empty? 
    end

    # delete storage folder if record is deleted
    def delete_storage_folder
        FileUtils.rm_rf(folderPath) if File.directory?(folderPath)
    end
end
