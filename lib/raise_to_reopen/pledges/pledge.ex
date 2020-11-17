defmodule RaiseToReopen.Pledges.Pledge do
  @moduledoc false

  import Ecto.Changeset

  defstruct [
    :amount,
    :email,
    :first_name,
    :last_name,
    public?: true
  ]

  @types %{
    amount: :integer,
    email: :string,
    first_name: :string,
    last_name: :string,
    public?: :boolean
  }

  def changeset(%__MODULE__{} = struct, attrs) do
    {struct, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_format(:email, ~r/@/)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:last_name, max: 30)
    |> validate_number(:amount, greater_than: 0)
    |> validate_required([:email, :first_name, :last_name, :amount, :public?])
  end
end