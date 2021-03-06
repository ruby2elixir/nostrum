defmodule Nostrum.Struct.Guild.Member do
  @moduledoc ~S"""
  Struct representing a Discord guild member.

  A `Nostrum.Struct.Guild.Member` stores a `Nostrum.Struct.User`'s properties
  pertaining to a specific `Nostrum.Struct.Guild`.

  ## Mentioning Members in Messages

  A `Nostrum.Struct.Guild.Member` can be mentioned in message content using the `String.Chars`
  protocol or `mention/1`.

  ```Elixir
  member = %Nostrum.Struct.Guild.Member{user: Nostrum.Struct.User{id: 120571255635181568}}
  Nostrum.Api.create_message!(184046599834435585, "#{member}")
  %Nostrum.Struct.Message{content: "<@120571255635181568>"}

  member = %Nostrum.Struct.Guild.Member{user: Nostrum.Struct.User{id: 89918932789497856}}
  Nostrum.Api.create_message!(280085880452939778, "#{Nostrum.Struct.Guild.Member.mention(member)}")
  %Nostrum.Struct.Message{content: "<@89918932789497856>"}
  ```
  """

  alias Nostrum.Struct.Snowflake
  alias Nostrum.Struct.User
  alias Nostrum.Util

  defstruct [
    :user,
    :nick,
    :roles,
    :joined_at,
    :deaf,
    :mute
  ]

  defimpl String.Chars do
    def to_string(member), do: @for.mention(member)
  end

  @typedoc "The user struct"
  @type user :: User.t()

  @typedoc "The nickname of the user"
  @type nick :: String.t() | nil

  @typedoc "A list of role ids"
  @type roles :: [Snowflake.t()]

  @typedoc "Date the user joined the guild"
  @type joined_at :: String.t()

  @typedoc "Whether the user is deafened"
  @type deaf :: boolean

  @typedoc "Whether the user is muted"
  @type mute :: boolean

  @type t :: %__MODULE__{
          user: user,
          nick: nick,
          roles: roles,
          joined_at: joined_at,
          deaf: deaf,
          mute: mute
        }

  @doc ~S"""
  Formats a `Nostrum.Struct.Guild.Member` into a mention.

  ## Examples

  ```Elixir
  iex> member = %Nostrum.Struct.Guild.Member{user: %Nostrum.Struct.User{id: 177888205536886784}}
  ...> Nostrum.Struct.Guild.Member.mention(member)
  "<@177888205536886784>"
  ```
  """
  @spec mention(t) :: String.t()
  def mention(%__MODULE__{user: user}), do: User.mention(user)

  @doc false
  def p_encode do
    %__MODULE__{
      user: User.p_encode()
    }
  end

  @doc false
  def to_struct(map) do
    new =
      map
      |> Map.new(fn {k, v} -> {Util.maybe_to_atom(k), v} end)
      |> Map.update(:user, nil, &Util.cast(&1, {:struct, User}))
      |> Map.update(:roles, nil, &Util.cast(&1, {:list, Snowflake}))

    struct(__MODULE__, new)
  end
end
