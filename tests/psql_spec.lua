describe("psql", function ()
  it("can be required", function ()
   require("psql")
  end)

  it("contains the database table", function ()
    local psql = package.loaded['psql']
    assert.are.same(psql._databases[1].name, "dbname")
  end)
end)
