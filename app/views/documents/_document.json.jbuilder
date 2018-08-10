json.extract! document, :id, :title, :content, :files, :created_at, :updated_at
json.url document_url(document, format: :json)
