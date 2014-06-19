module Import
  module PartCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
    end
  end

  module ClassMethods
    @@csv_cols=nil

    def uniq_key
      %w(id)
    end

    def csv_headers
      @@csv_cols.collect { |col| col.header }
    end

    def down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.unit_pack
      }
    end

    def init_csv_cols
      @@csv_cols=[]
      @@csv_cols<< Csv::CsvCol.new(field: 'id', header: 'PartNr')
      @@csv_cols<< Csv::CsvCol.new(field: 'unit_pack', header: 'UnitPack')
      @@csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
    end

    def csv_cols
      @@csv_cols
    end
  end
end